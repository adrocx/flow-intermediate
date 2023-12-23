import FungibleToken from 0x05
import AdrocxToken from 0x06
import FlowToken from 0x05
import SwapperContract from 0x06

transaction (amount: UFix64) {
    let swapper: &SwapperContract.Swapper
    let flowVault: &FungibleToken.Vault
    let ADRXVault: &AdrocxToken.Vault{FungibleToken.Receiver}
    prepare (signer: AuthAccount) {

        self.swapper = signer.borrow<&SwapperContract.Swapper>(from: /storage/ADRXSwapper) ?? panic ("mint a swapper first")

        self.flowVault = signer.borrow<&FlowToken.Vault>(from: /storage/flowToken) ?? panic("You do not have a flow Vault")

        self.ADRXVault = signer.borrow<&AdrocxToken.Vault>(from: AdrocxToken.VaultStoragePath) ?? panic("You do not have a ADRX Vault")
    }

    execute {
        self.ADRXVault.deposit(from:<- self.swapper.Swap(from: self.flowVault, amount: amount))
    }
}
