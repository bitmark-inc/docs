---
title: Bitmark Shares
keywords: bitmark shares
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-appendix/bitmark-shares
folder: bitmark-appendix
---

# Bitmark shares

The Bitmark Property System offers a shares functionality that can be used to split a digital asset into shares.

## The Reasoning

* There may be a need to turn a particular property into shares
  in order to divide the ownership or to treat it a fungible item for
  trading purposes.

* Once a property has been divided it does not make sense to
  reassemble it back into a single unit again since the single chain
  of provenance has been broken into multiple threads.

* The number of shares initially created is a fixed amount and cannot
  be changed as this would fundamentally alter the valuation of one
  share.

* Shares can be freely traded in any quantity without keeping a linked
  history.  i.e., there is no real order to shares transactions after
  initial creation.

## The Actions

* Shares can be created.

* Shares can be granted from the original supply to other accounts.

* Accounts holding shares can effectively trade them, but only among
  holders of a single Bitmark Share (i.e., the same Share ID). This leads
  to the need for a **swap** action, to do inter-share trading or
  something approximating to currency exchange.  This could also be
  used to swap out old shares for new shares with a different total
  amount.

* account holders must be able to determine their balance.

## The Implementation

* There is an initial creation **Balance Record** that turns a digital asset into shares: it permanently
  sets the total number of a particular share, it terminates the
  provenance of that property to prevent further transfers, and it
  allocates all the shares created to the current property owner.

* Any owner with a non-zero share balance can grant shares from that
  balance to another account using a **Grant Record**.  There can be
  several grants for the same share to different accounts from one
  owner in the same block, provided the total is within the owner's
  current balance.

* There is a special **Swap Record** to allow for an atomic swap of shares of different properties.

* Both **Grant** and **Swap** have an expiry to limit how long a one-signature
  transaction can be held before countersigning and submitting must
  take place.  This ensures the balances are predictable to the
  observing users.

    * In a normal transfer a double spend is prevented because there
      is only a single line of provenance.
    * shares are simple withdraw and deposit actions and have no
      particular ordering requirement other than not exceeding the
      available balance at the start of a block.
    * There is no concept like UTXO and inputs pointing to such items.

* There is a separate **Balance** RPC to read the list of balances for
  any owner starting at an arbitrary share id.  Since only non-zero
  shares are kept, it is not possible to distinguishing between the
  case of having granted all shares and the case of never had any
  shares - though this could be achieved by examining the blockchain
  from share creation to present for transactions by that account on
  the share in question.

* A data-table is kept of every non-zero balance.  Any balance record
  that would become zero by a Grant or Swap is deleted.
