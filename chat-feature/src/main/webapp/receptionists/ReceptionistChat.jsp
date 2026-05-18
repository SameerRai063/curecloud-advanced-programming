<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Receptionist Chat</title>
    <script>
        async function sendMessage() {
            const senderId = document.getElementById('senderId').value;
            const receiverId = document.getElementById('receiverId').value;
            const senderName = document.getElementById('senderName').value;
            const receiverName = document.getElementById('receiverName').value;
            const senderRole = 'receptionist';
            const message = document.getElementById('message').value;

            const form = new URLSearchParams();
            form.append('senderId', senderId);
            form.append('receiverId', receiverId);
            form.append('senderName', senderName);
            form.append('receiverName', receiverName);
            form.append('senderRole', senderRole);
            form.append('message', message);

            const res = await fetch('<%=request.getContextPath()%>/sendMessage', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: form.toString()
            });
            const json = await res.json();
            if (json.success) {
                const list = document.getElementById('messages');
                const li = document.createElement('li');
                li.textContent = senderName + ': ' + message;
                list.appendChild(li);
                document.getElementById('message').value = '';
            } else {
                alert('Send failed');
            }
        }
    </script>
</head>
<body>
<h2>Receptionist Chat</h2>
<!-- In a real app, populate these fields from session/user data -->
<input type="hidden" id="senderId" value="${sessionScope.userId}" />
<input type="hidden" id="senderName" value="${sessionScope.userName}" />
<input type="hidden" id="receiverId" value="1" />
<input type="hidden" id="receiverName" value="Patient" />

<ul id="messages"></ul>
<textarea id="message" rows="3" cols="50"></textarea><br/>
<button onclick="sendMessage()">Send</button>
</body>
</html>

