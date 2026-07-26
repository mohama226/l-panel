<?php

declare(strict_types=1);

namespace App\Core;

use Dotenv\Dotenv;

class Migrator
{
    public function run(): void
    {
        // Load .env
        $dotenv = Dotenv::createImmutable('/opt/l-panel');
        $dotenv->load();

        // Initialize database
        $db = new Database();

        echo "Migration started\n";

        // Load SQL migration files
        $files = glob(ROOT_PATH . '/database/migrations/*.sql');

        foreach ($files as $file) {

            $sql = file_get_contents($file);

            $db->connection()
               ->exec($sql);
        }
    }
}
