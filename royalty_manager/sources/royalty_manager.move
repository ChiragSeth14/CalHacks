module royalty_manager::royalty_manager {
    public struct MusicTrack has key {
        id: UID,
        track_id: u64,
        owner: address,
        title: u8,
        artist: u8,
        value: u64,
        royalties: u64
    }

    public fun new(track_id: u64, owner: address, title: u8, artist: u8, value: u64, royalties: u64, ctx: &mut TxContext): MusicTrack {
        MusicTrack {
            id: object::new(ctx),
            track_id,
            owner,
            title,
            artist,
            value,
            royalties
        }
    }

    public entry fun create_new_track(track_id: u64, owner: address, title: u8, artist: u8, value: u64, royalties: u64, ctx: &mut TxContext) {
        let track = new(track_id, owner, title, artist, value, royalties, ctx);
        transfer::transfer(track, tx_context::sender(ctx));
    }

    public entry fun transfer(track: MusicTrack, recipient: address) {
        transfer::transfer(track, recipient);
    }

    public fun play_track(track: &mut MusicTrack) {
        track.value = track.value + 1;

        distribute_royalties(track);
    }

    public entry fun distribute_royalties(track: &mut MusicTrack) {
        let royalty_percentage = 80 * 1000;
        let streaming_rate = 4 * 1000;
        track.royalties = track.royalties + ((streaming_rate * royalty_percentage) / (100 * 1000));
    }
}