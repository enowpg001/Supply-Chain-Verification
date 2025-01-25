;; Product Registry Contract

(define-non-fungible-token product-nft uint)

(define-map products uint {
    name: (string-ascii 50),
    manufacturer: principal,
    current-owner: principal,
    creation-time: uint,
    description: (string-utf8 500)
})

(define-data-var product-id-nonce uint u0)

(define-public (register-product (name (string-ascii 50)) (description (string-utf8 500)))
    (let
        ((new-id (+ (var-get product-id-nonce) u1)))
        (try! (nft-mint? product-nft new-id tx-sender))
        (map-set products new-id {
            name: name,
            manufacturer: tx-sender,
            current-owner: tx-sender,
            creation-time: block-height,
            description: description
        })
        (var-set product-id-nonce new-id)
        (ok new-id)
    )
)

(define-public (transfer-product (product-id uint) (new-owner principal))
    (let
        ((product (unwrap! (map-get? products product-id) (err u404))))
        (asserts! (is-eq (get current-owner product) tx-sender) (err u403))
        (try! (nft-transfer? product-nft product-id tx-sender new-owner))
        (ok (map-set products product-id
            (merge product { current-owner: new-owner })))
    )
)

(define-read-only (get-product-info (product-id uint))
    (map-get? products product-id)
)

(define-read-only (get-product-owner (product-id uint))
    (ok (nft-get-owner? product-nft product-id))
)

