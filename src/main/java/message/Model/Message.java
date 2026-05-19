package message.Model;

import Conversation.Model.Conversation;
import User.Model.User;
import java.sql.Timestamp;

public class Message {

    private int id;

    private int conversationId;

    private int senderId;

    private String messageText;

    private Timestamp sentAt;

    private boolean isRead;

    // Relationships (kept as plain references, managed manually by DAOs)
    private Conversation conversation;
    private User sender;

    // Constructors
    public Message() {}

    public Message(int conversationId, int senderId, String messageText) {
        this.conversationId = conversationId;
        this.senderId = senderId;
        this.messageText = messageText;
        this.isRead = false;
    }

    // Getters & Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getConversationId() { return conversationId; }
    public void setConversationId(int conversationId) { this.conversationId = conversationId; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public String getMessageText() { return messageText; }
    public String getMessage() { return messageText; } // For backward compatibility
    public void setMessage(String message) { this.messageText = message; }
    public void setMessageText(String messageText) { this.messageText = messageText; }

    public Timestamp getSentAt() { return sentAt; }
    public Timestamp getCreatedAt() { return sentAt; } // For backward compatibility
    public void setCreatedAt(Timestamp sentAt) { this.sentAt = sentAt; }
    public void setSentAt(Timestamp sentAt) { this.sentAt = sentAt; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public Conversation getConversation() { return conversation; }
    public void setConversation(Conversation conversation) { this.conversation = conversation; }

    public User getSender() { return sender; }
    public void setSender(User sender) { this.sender = sender; }
}