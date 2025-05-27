use starknet::ContractAddress;

#[starknet::interface]
trait ITrackUserRewards<TContractState>{
    fn add_points(ref self: TContractState, account: ContractAddress, value: felt252);
    fn redeem_points(ref self: TContractState, account: ContractAddress, value: felt252);
    fn get_points(self: @TContractState, account: ContractAddress) -> felt252;
}

#[starknet::contract]
mod TrackUserRewards {
    use starknet::ContractAddress;
    use starknet::storage::{StorageMapReadAccess, StorageMapWriteAccess, Map};
    use super::ITrackUserRewards;

    #[storage]
    struct Storage {
        user: Map<ContractAddress, felt252>,
    }

    #[abi(embed_v0)]
    impl TrackUserRewards of ITrackUserRewards<ContractState> {

        fn add_points(ref self: ContractState, account: ContractAddress, value: felt252) {
            let current = self.user.read(account);
            self.user.write(account, current + value)
        }

        fn redeem_points(ref self: ContractState, account: ContractAddress, value: felt252) {
            let current = self.user.read(account);
            self.user.write(account, current - value);
        }

        fn get_points(self: @ContractState, account: ContractAddress) -> felt252 {
            self.user.read(account)
        }
    }
}