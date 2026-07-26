<?php

declare(strict_types=1);

namespace App\Core;

class Container
{
    private array $items=[];

    public function set(string $name,mixed $object):void
    {
        $this->items[$name]=$object;
    }

    public function get(string $name):mixed
    {
        return $this->items[$name]??null;
    }

    public function has(string $name):bool
    {
        return isset($this->items[$name]);
    }
}
