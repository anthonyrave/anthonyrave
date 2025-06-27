<?php

declare(strict_types=1);

namespace AnthonyRave;

/**
 * A sample class for demonstrating PHPStan static analysis
 */
class Hello
{
    private string $name;

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function greet(): string
    {
        return "Hello, " . $this->name . "!";
    }

    public function getName(): string
    {
        return $this->name;
    }
}