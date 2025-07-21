;; Inspection Scheduling Contract
;; Coordinates annual hydrant testing and flow checks

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u200))
(define-constant ERR-INSPECTION-NOT-FOUND (err u201))
(define-constant ERR-INVALID-DATE (err u202))
(define-constant ERR-INSPECTOR-NOT-CERTIFIED (err u203))
(define-constant ERR-INSPECTION-ALREADY-COMPLETED (err u204))

;; Inspection Status Constants
(define-constant STATUS-SCHEDULED u1)
(define-constant STATUS-IN-PROGRESS u2)
(define-constant STATUS-COMPLETED u3)
(define-constant STATUS-FAILED u4)

;; Data Variables
(define-data-var next-inspection-id uint u1)

;; Data Maps
(define-map inspections
  { inspection-id: uint }
  {
    hydrant-id: uint,
    inspector: principal,
    scheduled-date: uint,
    completion-date: (optional uint),
    status: uint,
    flow-rate: (optional uint),
    pressure-reading: (optional uint),
    notes: (string-ascii 200)
  }
)

(define-map certified-inspectors principal bool)
(define-map authorized-users principal bool)

;; Authorization Functions
(define-public (add-authorized-user (user principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (map-set authorized-users user true))
  )
)

(define-public (certify-inspector (inspector principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (map-set certified-inspectors inspector true))
  )
)

(define-private (is-authorized (user principal))
  (or (is-eq user CONTRACT-OWNER)
      (default-to false (map-get? authorized-users user)))
)

;; Core Functions
(define-public (schedule-inspection (hydrant-id uint) (inspector principal) (scheduled-date uint))
  (let ((inspection-id (var-get next-inspection-id)))
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (default-to false (map-get? certified-inspectors inspector)) ERR-INSPECTOR-NOT-CERTIFIED)
    (asserts! (> scheduled-date block-height) ERR-INVALID-DATE)

    (map-set inspections
      { inspection-id: inspection-id }
      {
        hydrant-id: hydrant-id,
        inspector: inspector,
        scheduled-date: scheduled-date,
        completion-date: none,
        status: STATUS-SCHEDULED,
        flow-rate: none,
        pressure-reading: none,
        notes: ""
      }
    )
    (var-set next-inspection-id (+ inspection-id u1))
    (ok inspection-id)
  )
)

(define-public (complete-inspection (inspection-id uint) (flow-rate uint) (pressure-reading uint) (notes (string-ascii 200)))
  (let ((inspection-data (unwrap! (map-get? inspections { inspection-id: inspection-id }) ERR-INSPECTION-NOT-FOUND)))
    (asserts! (is-eq tx-sender (get inspector inspection-data)) ERR-NOT-AUTHORIZED)
    (asserts! (not (is-eq (get status inspection-data) STATUS-COMPLETED)) ERR-INSPECTION-ALREADY-COMPLETED)

    (map-set inspections
      { inspection-id: inspection-id }
      (merge inspection-data {
        completion-date: (some block-height),
        status: STATUS-COMPLETED,
        flow-rate: (some flow-rate),
        pressure-reading: (some pressure-reading),
        notes: notes
      })
    )
    (ok true)
  )
)

;; Read-only Functions
(define-read-only (get-inspection (inspection-id uint))
  (map-get? inspections { inspection-id: inspection-id })
)

(define-read-only (is-inspector-certified (inspector principal))
  (default-to false (map-get? certified-inspectors inspector))
)

(define-read-only (get-next-inspection-id)
  (var-get next-inspection-id)
)
