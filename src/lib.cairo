use starknet::ContractAddress;

#[starknet::interface]
trait ITrackUserRewards<TContractState>{
    fn add_points(ref self: TContractState, user: ContractAddress, value: felt252);
    fn redeem_points(ref self: TContractState, user: ContractAddress, value: felt252);
    fn get_points(self: @TContractState, user: ContractAddress) -> felt252;
}

#[starknet::contract]
mod TrackUserRewards {
    use starknet::ContractAddress;
    use starknet::storage::{StorageMapReadAccess, StorageMapWriteAccess, Map};
    use super::ITrackUserRewards;

    #[storage]
    struct Storage {
        user_points: Map<ContractAddress, felt252>,
    }

    #[abi(embed_v0)]
    impl TrackUserRewards of ITrackUserRewards<ContractState> {

        fn add_points(ref self: ContractState, user: ContractAddress, value: felt252) {
            let current = self.user_points.read(user);
            self.user_points.write(user, current + value)
        }

        fn redeem_points(ref self: ContractState, user: ContractAddress, value: felt252) {
            let current = self.user_points.read(user);
            self.user_points.write(user, current - value);
        }

        fn get_points(self: @ContractState, user: ContractAddress) -> felt252 {
            self.user_points.read(user)
        }
    }
}