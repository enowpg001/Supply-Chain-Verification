;; Verification Checkpoints Contract

(define-map checkpoints
    { product-id: uint, checkpoint-id: uint }
    { verifier: principal, timestamp: uint, location: (string-ascii 50), notes: (string-utf8 500) }
)

(define-map product-checkpoint-count uint uint)

(define-public (add-checkpoint (product-id uint) (location (string-ascii 50)) (notes (string-utf8 500)))
    (let
        ((checkpoint-id (default-to u0 (map-get? product-checkpoint-count product-id))))
        (map-set checkpoints
            { product-id: product-id, checkpoint-id: checkpoint-id }
            { verifier: tx-sender, timestamp: block-height, location: location, notes: notes }
        )
        (map-set product-checkpoint-count product-id (+ checkpoint-id u1))
        (ok checkpoint-id)
    )
)

(define-read-only (get-checkpoint (product-id uint) (checkpoint-id uint))
    (map-get? checkpoints { product-id: product-id, checkpoint-id: checkpoint-id })
)

(define-read-only (get-checkpoint-count (product-id uint))
    (default-to u0 (map-get? product-checkpoint-count product-id))
)

