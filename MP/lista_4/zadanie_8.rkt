#lang racket

;Zadanie 8

( define-struct ord ( val priority ) #:transparent )
( define-struct hleaf () )
( define-struct hnode ( elem rank l r ) #:transparent )
( define ( my-make-node elem heap-a heap-b )
   (cond [(hleaf? heap-a) heap-b];czy a pusty
         [(hleaf? heap-b) heap-a];czy b pusty
         ))
( define ( hord? p h )
   (or ( hleaf? h )
       (<= p ( ord-priority ( hnode-elem h ) ) ) ) )
( define ( rank h )
   (if ( hleaf? h )
       0
       ( hnode-rank h ) ) )
( define ( heap? h )
   (or ( hleaf? h )
       (and ( hnode? h )
            ( heap? ( hnode-l h ) )
            ( heap? ( hnode-r h ) )
            (<= ( rank ( hnode-r h ) )
                ( rank ( hnode-l h ) ) )
            (= ( hnode-rank h ) (+ 1 ( hnode-rank ( hnode-r h ) ) ) )
            ( hord? ( ord-priority ( hnode-elem h ) )
                   ( hnode-l h ) )
            ( hord? ( ord-priority ( hnode-elem h ) )
                   ( hnode-r h ) ) ) ) )
