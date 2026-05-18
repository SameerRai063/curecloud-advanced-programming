<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Receptionist Chat</title>
    <script>
        // WebSocket client for receptionist
        let chatWs = null;
        function initWs() {
            const senderId = document.getElementById('senderId').value;
            if (!senderId) return;
            const protocol = location.protocol === 'https:' ? 'wss' : 'ws';
            const url = protocol + '://' + location.host + '<%=request.getContextPath()%>/ws/chat?userId=' + encodeURIComponent(senderId);
            chatWs = new WebSocket(url);
            chatWs.onmessage = function (ev) {
                try {
                    const obj = JSON.parse(ev.data);
                    const list = document.getElementById('messages');
                    const li = document.createElement('li');
                    li.textContent = obj.senderName + ': ' + obj.message;
                    list.appendChild(li);
                } catch (e) { console.error(e); }
            };
            chatWs.onopen = function() { console.log('Chat WS open'); };
            chatWs.onclose = function() { console.log('Chat WS closed'); };
        }

        async function sendMessage() {
            const senderId = document.getElementById('senderId').value;
            const receiverId = document.getElementById('receiverId').value;
            const senderName = document.getElementById('senderName').value;
            const receiverName = document.getElementById('receiverName').value;
            const senderRole = 'receptionist';
            const message = document.getElementById('message').value;

            const payload = {
                senderId: parseInt(senderId||0),
                receiverId: parseInt(receiverId||0),
                senderName: senderName || '',
                receiverName: receiverName || '',
                senderRole: senderRole,
                message: message || ''
            };

            if (chatWs && chatWs.readyState === WebSocket.OPEN) {
                chatWs.send(JSON.stringify(payload));
                document.getElementById('message').value = '';
                return;
            }

            // fallback to HTTP POST
            const form = new URLSearchParams();
            Object.keys(payload).forEach(k => form.append(k, payload[k]));
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

        window.addEventListener('load', initWs);
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

