(define-fungible-token eco-token)

;; Map to store user's total recycled weight
(define-map user-recycle {user: principal} {total: uint})

;; Admin who can update reward multiplier
(define-constant admin 'SP000000000000000000002Q6VF78)

;; Reward rate (tokens per kg), default 1
(define-data-var reward-multiplier uint u1)

;; Log a recycling action and mint tokens
(define-public (log-eco-action (material (string-ascii 20)) (weight uint))
  (begin
    ;; Validate input
    (asserts! (> weight u0) (err {message: "Invalid weight                              ", tokens: u0}))

    ;; Update user's total recycled weight
    (let ((prev (match (map-get? user-recycle {user: tx-sender}) tuple (get total tuple) u0)))
      (map-set user-recycle {user: tx-sender} {total: (+ prev weight)})
    )

    ;; Calculate and mint reward tokens
    (let ((rate (var-get reward-multiplier))
          (reward (* weight rate)))
      (match (ft-mint? eco-token reward tx-sender)
        success
          (begin
            (print {event: "log-eco", user: tx-sender, material: material, weight: weight, reward: reward})
            (ok {message: "Action logged                               ", tokens: reward})
          )
        error
          (err {message: "Mint failed                                 ", tokens: u0})
      )
    )
  )
)

;; Admin can update the reward rate
(define-public (set-reward-rate (new-rate uint))
  (begin
    (asserts! (is-eq tx-sender admin) (err "Unauthorized"))
    (var-set reward-multiplier new-rate)
    (ok "Reward rate updated")
  )
)

;; View how much a user has recycled
(define-read-only (get-total-recycled (user principal))
  (ok (match (map-get? user-recycle {user: user}) tuple (get total tuple) u0))
)

;; Check a user's token balance
(define-read-only (get-token-balance (user principal))
  (ok (ft-get-balance eco-token user))
)
