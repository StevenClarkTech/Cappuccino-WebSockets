@import <Foundation/CPObject.j>
@import "socket.io.js"

var SharedSocket = nil;

@implementation SCSocket : CPObject
{
    JSObject socket;
    id delegate;
}

- (id)initWithURL:(CPURL)aURL
{
    self = [super init];
    if (self)
    {

     socket = io.connect([aURL absoluteString]);
     CPLog('attempting to connect to ' + [aURL absoluteString]);
    socket.on('connect_error', function (m) { CPLog("error: " + m); });
    socket.on('connect', function (m) { CPLog("socket.io connection open"); });
    socket.on('message', function (m) { CPLog(m); });

        //socket = new io.Socket([aURL host], {port:[aURL port], transports:['websocket', 'server-events', 'htmlfile', 'xhr-multipart', 'xhr-polling']});
      //  socket = new io.Socket('localhost');

      //  socket.connect();
    }
    return self;
}

- (void)setDelegate:(id)aDelegate
{

    delegate = aDelegate;
    if ([delegate respondsToSelector:@selector(socketDidConnect:)])
        socket.on('connect', function() {[delegate socketDidConnect:self]; [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];});
    if ([delegate respondsToSelector:@selector(socketDidClose:)])
        socket.on('close', function() {[delegate socketDidClose:self]; [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];});
    if ([delegate respondsToSelector:@selector(socketDidDisconnect:)])
        socket.on('disconnect', function() {[delegate socketDidDisconnect:self];[[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];});
    if ([delegate respondsToSelector:@selector(socket:didReceiveMessage:)])
        socket.on('message', function(message) {[delegate socket:self didReceiveMessage:message]; [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];});

}

- (void)sendMessage:(JSObject)jsonData
{

CPLog('attempint to send message');

socket.emit('deal', { hello: 'world' });

  //  socket.send([CPString JSONFromObject:jsonData]);
}

+ (SCSocket)sharedSocket
{
    if (!SharedSocket)
        SharedSocket = [[SCSocket alloc] initWithURL:[CPURL URLWithString:"http://localhost:8000"]];
    return SharedSocket;
}
@end
