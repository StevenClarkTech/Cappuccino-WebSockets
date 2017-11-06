@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
@import "RFPlayer.j"
@import "SCSocket.j"

@implementation RFObjectManager : CPObject
{
	CPDictionary playerDictionary @accessors(getter=playerDictionary);
}

- (id)init
{

    self = [super init];

    playerDictionary = @{
		@"seat1": [CPNull null],
		@"seat2": [CPNull null],
		@"seat3": [CPNull null],
		@"seat4": [CPNull null],
		@"seat5": [CPNull null],
		@"seat6": [CPNull null]
    };

    return self;
}

- (id)initWithFakeData
{

    self = [super init];

    playerDictionary = @{
		@"seat1": [[RFPlayer alloc] initWithName:@"Jake" andChips:3183],
		@"seat2": [CPNull null],
		@"seat3": [[RFPlayer alloc] initWithName:@"Anthony" andChips:1337],
		@"seat4": [CPNull null],
		@"seat5": [CPNull null],
		@"seat6": [[RFPlayer alloc] initWithName:@"Steven" andChips:569],
    };

		[[SCSocket sharedSocket] setDelegate:self];

    return self;
}

- (RFPlayer)hero{
	return [[RFPlayer alloc] initWithName:@"Hero" andChips:1000];
}

- (void)socketDidConnect:(SCSocket)aSocket
{
	CPLog('did connect');
}

- (void)socketDidClose:(SCSocket)aSocket
{
	CPLog('did close');
}

- (void)socketDidDisconnect:(SCSocket)aSocket
{
	CPLog('did disconnect');
}

- (void)socket:(SCSocket)aSocket didReceiveMessage:(JSObject)jsonData
{
		//var string = [CPString JSONFromObject:jsonData];
		//var result = CPJSObjectCreateWithJSON(string);
		var players_sat = jsonData.players_sat;
		for (var key in players_sat) {
		    if (players_sat.hasOwnProperty(key)) {
					var player = players_sat[key];

					[playerDictionary setObject:[[RFPlayer alloc] initWithName:player.name andChips:1000] forKey:player.seat];
		        console.log(key + " -> " + player.name);
		    }
		}

		CPLog('did JSON: ' + [CPString JSONFromObject:jsonData.players_sat]);
}


@end
