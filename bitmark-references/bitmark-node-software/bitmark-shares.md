# Bitmark shares

## Reasoning

* There may be some reason to turn a property into shares in order to
  divide the ownership.

* Once a property has been divided it does not make sense to combine
  it back into a single unit again.

* The number of shares initially created is a fixed amount and cannot
  be changed as this would fundamentally alter the valuation of one
  share.

* Shares can be freely traded in any quantity without keeping a linked
  history.  i.e. there is no real order to share transactions after
  initial creation.

## Actions that can be performed

* Shares can be created.

* Shares can be granted from the original supply to others.

* Accounts holding shares can effectively trade them, but only among
  holders of a single Bitmark Share.  This leads to a requirement of a
  **swap** action to do inter share trading or something approximating
  to currency exchange.  This could also be used to swap out old
  shares for new shares with a different total amount.

* account holders must be able to determine their balance.

## The implementation

* There is an initial creation **Balance Record** that permanently
  sets the total number of a particular share, it also terminates the
  provenance of that property to prevent further transfers and it
  allocates all the shares created to the current property owner.

* Any owner with a non-zero share balance can grant shares from that
  balance to another account using a **Grant Record**.  There can be
  several grants for the same share to different accounts from one
  owner in the same block, provided total is within the owner's
  current balance.

* There is a special **Swap Record** to allow for the atomic swap kind
  of trade.

* Both Grant and Swap have an expiry to limit how long a one signature
  transaction can be held before countersigning and submitting must
  take place.  This is to allow the balances to be predictable to the
  observing users.

    * In a normal transfer a double spend is prevented because there
      is only a single line of provenance.
    * shares are simple withdraw and deposit actions and have no
      particular ordering requirement other than not exceeding the
      available balance at the start of a block.
    * There is no concept like UTXO and inputs pointing to such items.

* There is a separate **Balance** RPC to read the list of balances for
  any owner starting at an arbitrary share id.  Since only non-zero
  shares are kept it is not possible to distinguishing between the
  case of having granted all shares and the case of never had any
  shares - though this could be achieved by examining the blockchain
  from share creation to present for transactions by that account on
  the share in question.

* A data-table is kept of every non-zero balance.  Any balance record
  that would become zero by a Grant or Swap is deleted.
