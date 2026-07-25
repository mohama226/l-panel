<?php
// app/OcservManager.php

class OcservManager
{
    public static function addUser($username, $password)
    {
        $cmd = sprintf('%s -c %s -a %s', OCSERV_BIN, OCSERV_PASSWD, escapeshellarg($username));
        return self::runCommand($cmd, $password . "\n" . $password . "\n");
    }

    public static function deleteUser($username)
    {
        $cmd = sprintf('%s -c %s -d %s', OCSERV_BIN, OCSERV_PASSWD, escapeshellarg($username));
        return self::runCommand($cmd);
    }

    public static function listUsers()
    {
        if (!file_exists(OCSERV_PASSWD)) {
            return [];
        }

        $lines = file(OCSERV_PASSWD, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        $users = [];

        foreach ($lines as $line) {
            $parts = explode(':', $line);
            if (!empty($parts[0])) {
                $users[] = $parts[0];
            }
        }

        return $users;
    }

    protected static function runCommand($cmd, $input = null)
    {
        $descriptorspec = [
            0 => ['pipe', 'r'],
            1 => ['pipe', 'w'],
            2 => ['pipe', 'w'],
        ];

        $process = proc_open($cmd, $descriptorspec, $pipes);

        if (!is_resource($process)) {
            return false;
        }

        if ($input !== null) {
            fwrite($pipes[0], $input);
        }
        fclose($pipes[0]);

        $output = stream_get_contents($pipes[1]);
        $error = stream_get_contents($pipes[2]);

        fclose($pipes[1]);
        fclose($pipes[2]);

        $return_value = proc_close($process);

        return [
            'success' => $return_value === 0,
            'output'  => $output,
            'error'   => $error,
        ];
    }
}
