<?php
session_start();

$_SESSION['urls'] ??= [];

$baseUrl = 'http://' . $_SERVER['HTTP_HOST'] . dirname($_SERVER['SCRIPT_NAME']);
$baseUrl = rtrim($baseUrl, '/') . '/';

$message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['longUrl'])) {
    $longUrl = trim($_POST['longUrl']);
    
    if (!filter_var($longUrl, FILTER_VALIDATE_URL)) {
        $message = '<div class="error">Invalid URL format</div>';
    } else {
        do {
            $shortCode = substr(str_shuffle('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'), 0, 7);
        } while (isset($_SESSION['urls'][$shortCode]));
        
        $_SESSION['urls'][$shortCode] = $longUrl;
        
        $shortUrl = $baseUrl . $shortCode;
        $message = '<div class="success">Short URL: <a href="' . $shortUrl . '" target="_blank">' . $shortUrl . '</a></div>';
    }
}

$requestPath = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$requestPath = ltrim($requestPath, '/');

if ($requestPath !== '' && $requestPath !== basename(__FILE__)) {
    if (isset($_SESSION['urls'][$requestPath])) {
        header('Location: ' . $_SESSION['urls'][$requestPath], true, 301);
        exit;
    }
    
    http_response_code(404);
    die('<h2>404 - Not Found</h2><p>This short link does not exist.</p>');
}
