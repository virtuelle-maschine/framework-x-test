<?php

declare(strict_types=1);

namespace VirtuelleMaschine\FrameworkXTest\Controller;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use React\Http\Message\Response;

class DummyController
{
    public function __construct(private readonly string $testText)
    {
    }

    public function __invoke(ServerRequestInterface $request):ResponseInterface
    {
        return Response::json(
            [
                'testText' => $this->testText,
                'id'       => $request->getAttribute('id')
            ]
        );
    }
}
