package message.websocket;

/**
 * WebSocket support was removed because this project does not include
 * the Jakarta WebSocket API dependency.
 *
 * This class remains as a harmless stub so existing imports can compile
 * while the app uses polling-based chat refresh instead.
 */
public final class ChatEndpoint {

    private ChatEndpoint() {
    }

    public static void sendToUser(int userId, String json) {
        // no-op
    }
}

