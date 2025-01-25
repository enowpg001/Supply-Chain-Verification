;; High-Value Items Contract

(define-non-fungible-token high-value-item uint)

(define-map high-value-items uint {
    name: (string-ascii 50),
    manufacturer: principal,
    current-owner: principal,
    creation-time: uint,
    description: (string-utf8 500),
    value: uint
})

(define-data-var item-id-nonce uint u0)

(define-public (register-high-value-item (name (string-ascii 50)) (description (string-utf8 500)) (value uint))
    (let
        ((new-id (+ (var-get item-id-nonce) u1)))
        (try! (nft-mint? high-value-item new-id tx-sender))
        (map-set high-value-items new-id {
            name: name,
            manufacturer: tx-sender,
            current-owner: tx-sender,
            creation-time: block-height,
            description: description,
            value: value
        })
        (var-set item-id-nonce new-id)
        (ok new-id)
    )
)

(define-public (transfer-high-value-item (item-id uint) (new-owner principal))
    (let
        ((item (unwrap! (map-get? high-value-items item-id) (err u404))))
        (asserts! (is-eq (get current-owner item) tx-sender) (err u403))
        (try! (nft-transfer? high-value-item item-id tx-sender new-owner))
        (ok (map-set high-value-items item-id
            (merge item { current-owner: new-owner })))
    )
)

(define-read-only (get-high-value-item-info (item-id uint))
    (map-get? high-value-items item-id)
)

(define-read-only (get-high-value-item-owner (item-id uint))
    (ok (nft-get-owner? high-value-item item-id))
)

