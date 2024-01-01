const std = @import("std");
const net = std.net;
const socket_address = net.Address;
const tcp_stream = net.StreamServer;
pub const io_mode = .evented;

pub fn main() !void {
    var tcp_stream_server = tcp_stream.init(.{});
    defer tcp_stream_server.close();
    const tcp_stream_address = try socket_address.resolveIp("127.0.0.1", 8700);
    try tcp_stream_server.listen(tcp_stream_address);

    while (true) {
        const tcp_stream_connection = try tcp_stream_server.accept();
        const bufSize = 4096;
        var buffer: [bufSize]u8 = undefined;
        const lines = try tcp_stream_connection.stream.reader().read(&buffer);
        try tcp_stream_connection.stream.writer()
            .writeAll("HTTP/1.1 200 OK\r\n\r\nHi from Server");
        std.debug.print("Your zig is ready and listening at.{}\n{s}\n", .{ tcp_stream_address, buffer[0..lines] });

        tcp_stream_connection.stream.close();
    }
}

test "simple test" {}
