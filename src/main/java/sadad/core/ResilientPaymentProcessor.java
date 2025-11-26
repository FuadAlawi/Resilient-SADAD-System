package sadad.core;

import java.math.BigDecimal;
import java.util.Objects;

public class ResilientPaymentProcessor {

    public record PaymentRequest(String payerId, String payeeId, BigDecimal amount, String currency) {}

    public record PaymentResult(String status, String reference) {}

    public PaymentResult process(PaymentRequest request) {
        validate(request);
        // TODO: integrate with ledger, idempotency, retries, circuit breaker
        String ref = "REF-" + System.currentTimeMillis();
        return new PaymentResult("ACCEPTED", ref);
    }

    private void validate(PaymentRequest request) {
        Objects.requireNonNull(request, "request");
        if (request.payerId() == null || request.payerId().isBlank()) {
            throw new IllegalArgumentException("payerId is required");
        }
        if (request.payeeId() == null || request.payeeId().isBlank()) {
            throw new IllegalArgumentException("payeeId is required");
        }
        if (request.amount() == null || request.amount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("amount must be > 0");
        }
        if (request.currency() == null || request.currency().isBlank()) {
            throw new IllegalArgumentException("currency is required");
        }
    }
}
