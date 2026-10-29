package org.idv.bursiyer.web;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.server.ResponseStatusException;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

@RestControllerAdvice
public class RestExceptionHandler {

    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<Map<String, Object>> handleResponseStatus(
            ResponseStatusException exception,
            HttpServletRequest request
    ) {
        HttpStatus status = HttpStatus.valueOf(exception.getStatusCode().value());
        String message = exception.getReason() != null && !exception.getReason().isBlank()
                ? exception.getReason()
                : status.getReasonPhrase();
        return ResponseEntity.status(status).body(body(status, message, request.getRequestURI()));
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Map<String, Object>> handleUnreadable(
            HttpServletRequest request
    ) {
        String path = request.getRequestURI();
        String message = path != null && path.contains("/evaluation")
                ? "Puan bilgisi okunamadı. Tüm kriterlere 0 veya daha büyük tam sayı girin."
                : "İstek gövdesi okunamadı";
        return ResponseEntity.badRequest().body(body(HttpStatus.BAD_REQUEST, message, path));
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<Map<String, Object>> handleConflict(
            HttpServletRequest request
    ) {
        String path = request.getRequestURI();
        String message = path != null && path.contains("/evaluation")
                ? "Bu puan kaydı zaten var. Sayfayı yenileyip tekrar kaydedin; mevcut puanınızın üzerine yazılır."
                : "Kayıt çakışması";
        return ResponseEntity.status(HttpStatus.CONFLICT).body(body(HttpStatus.CONFLICT, message, path));
    }

    private static Map<String, Object> body(HttpStatus status, String message, String path) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", Instant.now().toString());
        body.put("status", status.value());
        body.put("error", status.getReasonPhrase());
        body.put("message", message);
        body.put("path", path);
        return body;
    }
}
