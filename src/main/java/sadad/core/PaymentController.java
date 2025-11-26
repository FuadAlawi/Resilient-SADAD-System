package sadad.core;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1")
public class PaymentController {

    private final ResilientPaymentProcessor processor = new ResilientPaymentProcessor();

    @GetMapping("/healthz")
    public Map<String, String> health() {
        return Map.of("status", "ok");
    }

    @PostMapping("/payments/echo")
    public ResponseEntity<Map<String, Object>> echo(@RequestBody Map<String, Object> payload) {
        return ResponseEntity.ok(Map.of("received", payload));
    }
}
