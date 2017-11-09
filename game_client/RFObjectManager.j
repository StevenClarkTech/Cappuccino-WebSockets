@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
@import "RFPlayer.j"
@import "SCSocket.j"

@class AppController


@implementation RFObjectManager : CPObject
{
	CPDictionary playerDictionary @accessors(getter=playerDictionary);
	AppController	controller @accessors(setter=setController);
	int hero_sat;

	int seat_number_locally;
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
		@"seat1": [[RFPlayer alloc] initWithName:@"Obj1" andChips:3183],
		@"seat2": [CPNull null],
		@"seat3": [[RFPlayer alloc] initWithName:@"Obj3" andChips:1337],
		@"seat4": [CPNull null],
		@"seat5": [CPNull null],
		@"seat6": [[RFPlayer alloc] initWithName:@"Obj6" andChips:569],
    };
		hero_sat = 0;

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


// recieved a payload
- (void)socket:(SCSocket)aSocket didReceiveMessage:(JSObject)jsonData
{
		//var string = [CPString JSONFromObject:jsonData];
		//var result = CPJSObjectCreateWithJSON(string);
		playerDictionary = @{
		@"seat1": [CPNull null],
		@"seat2": [CPNull null],
		@"seat3": [CPNull null],
		@"seat4": [CPNull null],
		@"seat5": [CPNull null],
		@"seat6": [CPNull null]
    };

		hero_sat = [self seatForHeroFromList:jsonData.players_sat withName:'hero'+seat_number_locally];
		console.log('seat' + hero_sat);

			// infer which seat hero is in from players_sat[]


		var players_sat = jsonData.players_sat;


		for (var key in players_sat) {
		    if (players_sat.hasOwnProperty(key)) {
					var player = players_sat[key];
						if (player != [CPNull null]) {

						[playerDictionary setObject:[[RFPlayer alloc] initWithName:player.name andChips:1000] forKey:"seat"+player.seat];

						}
		    }
		}

		[controller refresh:self];


}

- (void)sitDownAtSeatNumber:(int)seat{

	var data = {"name": "hero", "seat": seat};
	seat_number_locally = seat;
	[[SCSocket  sharedSocket] emitMessage:"sitDown" withData:data];
}



// pragma mark -- helper methods

// returns the seat of where the hero is at the table, 0 if he's not sat
- (int)seatForHeroFromList:(CPArray)array withName:(CPString)name{

var i = 0;
var index = 0;
	array.forEach(function(player) {
		i++;
    if ([player.name isEqualToString:name] ) {
			index = i;
    };
});
console.log('should return i: ', index)

return index; // hero not sat?
}



@end
