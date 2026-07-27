<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;



class ActivityLog extends Model
{


    use HasFactory;



    /*
    |--------------------------------------------------------------------------
    | Table
    |--------------------------------------------------------------------------
    */

    protected $table = 'activity_logs';



    /*
    |--------------------------------------------------------------------------
    | Mass Assignment
    |--------------------------------------------------------------------------
    */

    protected $fillable = [

        'admin_id',
        'action',
        'model',
        'model_id',
        'description',
        'ip'

    ];



    /*
    |--------------------------------------------------------------------------
    | Casts
    |--------------------------------------------------------------------------
    */

    protected $casts = [

        'model_id' => 'integer'

    ];



    /*
    |--------------------------------------------------------------------------
    | Relations
    |--------------------------------------------------------------------------
    */



    /**
     * Admin who performed action
     */

    public function admin()
    {

        return $this->belongsTo(
            Admin::class,
            'admin_id'
        );

    }



    /*
    |--------------------------------------------------------------------------
    | Polymorphic Relation
    |--------------------------------------------------------------------------
    |
    | Example:
    |
    | User created
    | Server updated
    |
    */

    public function subject()
    {

        return $this->morphTo(
            null,
            'model',
            'model_id'
        );

    }



    /*
    |--------------------------------------------------------------------------
    | Static Logger
    |--------------------------------------------------------------------------
    |
    | Usage:
    |
    | ActivityLog::createLog(
    |   'create',
    |   $vpnUser,
    |   'VPN user created'
    | );
    |
    */


    public static function createLog(
        string $action,
        $model = null,
        ?string $description = null,
        ?int $adminId = null
    )
    {


        return self::create([


            'admin_id' => $adminId 
                ?? auth()->id(),



            'action' => $action,



            'model' => $model 
                ? get_class($model)
                : null,



            'model_id' => $model?->id,



            'description' => $description,



            'ip' => request()->ip()


        ]);

    }



    /*
    |--------------------------------------------------------------------------
    | Scopes
    |--------------------------------------------------------------------------
    */



    public function scopeLatestFirst($query)
    {

        return $query->orderBy(
            'created_at',
            'desc'
        );

    }



    public function scopeForAdmin($query,$adminId)
    {

        return $query->where(
            'admin_id',
            $adminId
        );

    }



    public function scopeAction($query,$action)
    {

        return $query->where(
            'action',
            $action
        );

    }


}
