body {
    background-color: #F7F8F8;
    height:100%;
    overflow: hidden;
}
fieldset{
    padding:0;
    margin:0;
}
/** default styles start */
/** Default styles for the chat window **/
#liveAgentChatLog { border: 0; width: 100%; height: 100%; }
#liveAgentChatLogText span { display: block; }
#liveAgentClientChat form { display: inline; }
#liveAgentChatLogText .name { display:inline-block; white-space: pre; }
#liveAgentChatLogText .messageText { display:inline; }

#liveAgentChatLogAlertMessage {
    background-color: #CD6571; 
    -webkit-animation: pulse 2s infinite alternate;
    -moz-animation: pulse 2s infinite alternate;
    -o-animation: pulse 2s infinite alternate;
    animation: pulse 2s infinite alternate;
    padding: 10px 10px 10px 10px;
    text-align: center;
    width:auto;
    bottom:0px;
    color: white;
    font-style: italic;
    overflow: hidden;
    display: none;
}

#liveAgentChatLogAlertMessage.chasitorTyping {
    background-color: #FEFCE4;
    -webkit-animation-name: none;
    -moz-animation-name: none;
    -o-animation-name: none;
    animation-name: none;
    color: #CD6571;
}

.liveAgentStateIdleAlert #liveAgentChatLogAlertMessage {
    display: block; 
}

#liveAgentChatLogAlertMessageTimer {
    font-weight: 700;
}

/* Animation for Chat Log Alert */
@-webkit-keyframes pulse {
      0% {background-color: #CD6571;}
     25% {background-color: #C85663;}
     50% {background-color: #C14251;}
     75% {background-color: #C85663;}
     100% {background-color: #CD6571;}
}

@-moz-keyframes pulse {
      0% {background-color: #CD6571;}
     25% {background-color: #C85663;}
     50% {background-color: #C14251;}
     75% {background-color: #C85663;}
     100% {background-color: #CD6571;}
}

@-o-keyframes pulse {
      0% {background-color: #CD6571;}
     25% {background-color: #C85663;}
     50% {background-color: #C14251;}
     75% {background-color: #C85663;}
     100% {background-color: #CD6571;}
}

@keyframes pulse {
      0% {background-color: #CD6571;}
     25% {background-color: #C85663;}
     50% {background-color: #C14251;}
     75% {background-color: #C85663;}
     100% {background-color: #CD6571;}
}

@-webkit-keyframes none {
      0% {background-color: #FFFEEC;}
     100% {background-color: #FFFEEC;}
}

@-moz-keyframes none {
      0% {background-color: #FFFEEC;}
     100% {background-color: #FFFEEC;}
}

@-o-keyframes none {
      0% {background-color: #FFFEEC;}
     100% {background-color: #FFFEEC;}
}

@keyframes none {
      0% {background-color: #FFFEEC;}
     100% {background-color: #FFFEEC;}
}


/** Hide chat elements prior to the chat starting **/
#liveAgentClientChat.liveAgentStateWaiting .liveAgentChatElement { display: block; }

/** Hide the end and send buttons when the chat has ended **/
#liveAgentClientChat.liveAgentStateEnded .liveAgentEndButton,
#liveAgentClientChat.liveAgentStateEnded .liveAgentSendButton,
#liveAgentClientChat.liveAgentStateEnded #customerChatInputPanel { display: none; }

/** Hide the status message **/
#liveAgentClientChat #liveAgentStateStatusMessage { display: none; }

/** Display the status message when in the status message state **/
#liveAgentClientChat.liveAgentStateStatusMessage #liveAgentStateStatusMessage { display: block; }

/** Hide the end and send buttons and chat log if a chat has not been started **/
.no_chat .liveAgentSaveButton,
.no_chat .liveAgentEndButton,
.no_chat #liveAgentChatLog { display: none; }

/** Hide the header text unless waiting for chat **/
.liveAgentStateWaiting #header_text { display: inline-block; padding-top: 8px; }
#header_text { display: none; }

/** Hide the save chat button if the setting is disabled **/
.no_save .liveAgentSaveButton { display: none; }

/** Hide the cancel button unless waiting for chat **/
#liveAgentClientChat.liveAgentStateWaiting .liveAgentCancelButton { display: inline; }
.liveAgentCancelButton { display: none; }

.liveAgentChatInput {
    width: auto;
    height: auto;
    background-color: #ffffff;
    border: 1px solid #bababa;
    padding: 6px;
}

#liveAgentClientChat textarea#liveAgentChatTextArea {
    color: #222;
    border: none;
    resize: none;
    width: 100%;
    white-space: pre-wrap;
    overflow-y: auto;
    overflow-x: hidden;
    background-color: #fff;
    line-height: 1.15em;
    -webkit-line-break: after-white-space;
    word-wrap: break-word;
    outline-style:none;
    height: 18px;
    display: block;
    font-size: 1em;
    padding: 0px;
    margin: 0px;
    font-family: "nta", Arial, sans-serif;
}

.no_brand #brand {
    display: none;
    height: 0;
}

.no_brand #transcript {
    top: 0;
}

/** Hide the file transfer buttons when the chat is ongoing**/
#liveAgentChatFileTransfer {
    display: none;
}

.file_transfer_requested #liveAgentChatFileTransfer {
    display: block;
}

.liveAgentFileDragArea {
    position: relative;
}
/** default styles end */

#banner { background-color:#0A0C0B;height:50px }
#blueBanner { height:5px; background-color:#005ea5; }
#container{
    margin: 0 20px 0 20px;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
    height: 100%;
    padding: 84px 0 43px 0;
    position:relative;
}
.liveAgentDequeued #container, .liveAgentStateEnded #container, .liveAgentStateWaiting #container {
    padding: 84px 0 0 0;
}
#toolbar {
    height:34px;  
    background-color:#333;
}

#liveAgentClientChat.liveAgentStateWaiting #toolbar {
	display:none;
}

#liveAgentMessageContainer div {
    font-style: italic;
    /*padding-top: 136px;*/
}
#customerChatInputPanel {
    min-height: 32px;
    position:absolute;
    left:0;
    bottom:0;
    margin:0;
    width:100%;
    background: #FFF;
    border-top: solid #D1D8E0 2px;
}
.liveAgentDequeued #customerChatInputPanel, .liveAgentStateEnded #customerChatInputPanel, .liveAgentStateWaiting #customerChatInputPanel {
    background: none;
    display: none;
}
#liveAgentMessageContainer button {
    display: none;
}

#liveAgentQueuePosition {
    padding-top:136px;
    text-align: center;
    font-weight: bold;
    display: block;
    font-size:1em;
}

.liveAgentStateWaiting #liveAgentQueuePosition {
    display:block;
}

.liveAgentState #liveAgentQueuePosition {
    display:none;
}

.liveAgentDequeued #liveAgentQueuePosition {
    display:block;
}
#liveAgentChatLog {
    width:100%;
    overflow: auto;
    overflow-x: hidden;
    border:0;
    padding-top:4px;
}
.liveAgentStateEnded #liveAgentChatLogText, .liveAgentStateIdleAlert #liveAgentChatLogText, .liveAgentStateStatusMessage #liveAgentChatLogText {
    padding-bottom: 72px
}
.liveAgentStateEnded #liveAgentChatLogTyping, .liveAgentStateIdleAlert #liveAgentChatLogTyping, .liveAgentStateStatusMessage #liveAgentChatLogTyping {
    display: block;
    margin-top: -72px;
    padding-bottom: 72px
}
#liveAgentChatLogTyping {
    font-size: .9em
}
#liveAgentChatLogText .name {
    display: block;
    line-height: 1.2;
    font-weight: bold;
}
#liveAgentChatLogText .bubble {
    margin:0;
}
#liveAgentChatLogText .messageText {
    line-height: 1.3;
}
#liveAgentChatLogText .operator .messageText {
    background-color: #DEEFF9;
}
#liveAgentChatLogText .client {
    text-align: right;
    clear:both;
    margin-right:6px;
}
#liveAgentChatLogText .client, #liveAgentChatLogText .operator, #liveAgentChatLogText .system {
    margin-bottom: 8px;
}
#liveAgentChatLogText .system {
    text-align: center;
    clear:both;
    padding-top: 16px;
}
#liveAgentChatLogText .client .messageText {
    background-color: #FFFFFF;
    border: 1px solid #E2E8ED;
}
#liveAgentChatLogText .messageText {
    display: inline-block;
    max-width: 90%;
    -moz-border-radius: 3px;
    border-radius: 3px;
    padding: 6px 8px;
}
#liveAgentChatLogText .timestamp {
    display: block;
    font-size: .9em;
    font-weight: 200;
    color: #929A9D;
    text-transform: uppercase;
    padding: 0 8px;
}
#liveAgentChatLogAlertMessage {
    position:absolute;
    bottom: 0;
    left: 30px;
    right: 41px;
}
.toolbar-text {
    line-height: normal;
    text-align:center;
    border-style: solid;
    border-width: 0;
    text-decoration: none;
    color: #fff;
    display: inline-block;
    float: right;
    margin: 5px 10px 5px 10px;
    font-size: .9em;
    padding: 2px 8px;
}
.c1{
    float:left;
    width: 400px;
}
.errorTxt {
    color: red;
}
#liveAgentChatLog form {
    background-color: #FFF;
}
.liveAgentSendButton { 
    -webkit-border-radius: 0;
    width:60px;
    background:#00823b; 
    padding:3px 0 4px 0; 
    font-size:1em; 
    color:#fff;
    outline: none;
    display: inline-block;
    border: none;
    padding:0.42em 0.7894736842em 0.2631578947em 0.7894736842em;
    color:#fff;
    border-bottom: 2px solid #003618;
    box-sizing: border-box;
    -webkit-font-smoothing: antialiased;
    line-height: 1.25;
    height:100%;
}
.liveAgentChatInput {
    min-height: 20px;
    border:0;
    padding: 6px;
    width: 100%;
    outline:none;
}
.hidden { display:none;}
.liveAgentSaveButton,.liveAgentEndButton,.liveAgentCancelButton {
    line-height: normal;
    text-align:center;
    border-style: solid;
    border-width: 0;
    cursor: pointer;
    text-decoration: none;
    max-height: 24px;
}

.liveAgentSaveButton {
    background: #6D7391;
    color: #fff;
    display: inline-block;
    float: left;
    margin: 5px 10px 5px 10px;
    border-radius: 3px;
    font-size: .9em;
    padding: 2px 8px;
}

.liveAgentEndButton {
    float: right;
    border-radius: 3px;
    background: #C14251;
    display: inline-block;
    color: #fff;
    margin: 5px 10px 5px 10px;
    font-size: .9em;
    padding: 2px 8px;
}

.liveAgentCancelButton {
    position: absolute;
    top: 54%;
    right: 42%;
    display: none;
    background: #6D7391;
    color: #fff;
    border-radius: 3px;
    padding: 4px 8px;
    font-size: 1.3em;
}

.liveAgentSaveButton:hover, .liveAgentCancelButton:hover {
    background-color: #8B8FA7;
    color: #fff;
    text-decoration: none;
}

.liveAgentEndButton:hover {
    background-color: #D54858;
}

.liveAgentSendButton:hover {
    background-color: #00692f;
}

#liveAgentClientChatSettings, #liveAgentClientChat, #chatContainer {
    height:100%
}
#chatContainer {
    position: relative;
}
#header {
    position:absolute;
    top:0;
    width:100%;
    z-index:1000;
}
.liveAgentStateWaiting #customerChatInputBox, .liveAgentDequeued #customerChatInputBox {
    display:none;
}
#liveAgentSaveButton {
    display:none;
}
.liveAgentAlert, .liveAgentMessage {
    text-align: center;
    position: absolute;
    bottom: 0;
    left: 20px;
    right: 20px;
    display:block;
    font-style: italic;
}
.liveAgentAlert p, .liveAgentMessage p {
    padding: 0 4px;
}
.liveAgentMessage {
    background: #FFFFDC;
}
.liveAgentAlert {
    background: #CD6571;
    color: white;
}