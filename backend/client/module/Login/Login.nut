local WLoginPos = ResolutionUtils.getCenterXY(400, 350);
local WLogin = GUI.Window(anx(WLoginPos.x), any(WLoginPos.y), anx(400), any(350), "MENU_INGAME.TGA", true, true);
const PADDING_LEFT = 10;
const PADDING_TOP = 80;
/**
 *
 * ACHTUNG: ein Package String kann nur 101 Characters lang sein.
 * Bedeutet Nickname + Trennzeichen + Passwort dürfen zusammen höchstens 101 zeichen lang sein
 * Passwort wird wohl noch gehasht, also vorsicht
 *
 */
local ETextWelcome = GUI.Draw(anx(PADDING_LEFT + 0), any(0),
format(@"
Wellcome unknown traveler,
some RP Server $$PLACEHOLDER$$.
You shall not pass(without authentication)!",
    getPlayerName(heroId)),
    WLogin);
ETextWelcome.setFont("FONT_DEFAULT.TGA");
ETextWelcome.setColor(255,255,255);

local ELabelNickname = GUI.Draw(anx(PADDING_LEFT + 0), any(PADDING_TOP + 10), "Nickname", WLogin);
local EInputNickname = GUI.Input(anx(PADDING_LEFT + 0), any(PADDING_TOP + 30), anx(380), any(25), "DLG_CONVERSATION.TGA", "FONT_OLD_20_WHITE_HI.TGA", Input.Text, Align.Left, "", 0, WLogin);
EInputNickname.selector = "|";
EInputNickname.maxLetters = 15;

local ELabelPassword = GUI.Draw(anx(PADDING_LEFT + 0), any(PADDING_TOP + 70), "Password", WLogin);
local EInputPassword = GUI.Input(anx(PADDING_LEFT + 0), any(PADDING_TOP + 90), anx(380), any(25), "DLG_CONVERSATION.TGA", "FONT_OLD_20_WHITE_HI.TGA", Input.Password, Align.Left, "", 0, WLogin);
EInputPassword.maxLetters = 15;

local EButtonLogin = GUI.Button(anx(PADDING_LEFT + 0), any(PADDING_TOP + 170), anx(80), any(25), "INV_SLOT_FOCUS.TGA", "Login", WLogin);
local EButtonRegister = GUI.Button(anx(310), any(PADDING_TOP + 170), anx(80), any(25), "INV_SLOT_FOCUS.TGA", "Register", WLogin);

local ELabelHelper = GUI.Draw(anx(PADDING_LEFT + 0), any(PADDING_TOP + 130), "", WLogin);

addEventHandler("onInit", function() {
    enableEvent_Render(true);
    showPlayerStatus(false);
    enable_NicknameId(true);
    setCursorVisible(true);
    WLogin.setVisible(true);
    Camera.setPosition(13480.0, 1810.0, -1640.0);
    local CamPosition = Camera.getPosition();

    Camera.setRotation(0.0, 215.0, 0.0);
    local CamRotation = Camera.getRotation();

    Camera.enableMovement(false);
    Camera.modeChangeEnabled = false;

});

addEventHandler(Network.Event.PlayerLoginFailed, function(packet) {
    print("Network.Event.PlayerLoginFailed");
    ELabelHelper.setVisible(true);
    ELabelHelper.setText(packet.readString());
    ELabelHelper.setColor(255,0,0);
});
addEventHandler(Network.Event.PlayerLoginSuccess, function(packet) {
    print("Network.Event.PlayerLoginSuccess");
    ELabelHelper.setVisible(true);
    ELabelHelper.setText(packet.readString());
    ELabelHelper.setColor(0,255,0);
    Camera.setTargetPlayer(heroId);
    Camera.enableMovement(true);
    Camera.modeChangeEnabled = true;
    WLogin.setVisible(false);
});

addEventHandler("GUI.onClick", function(self) {
    switch (self) {
        case EButtonLogin:
        /**
         * Do Username validation client side
         */
            packet <- Packet();
            packet.writeUInt8(PackageTypes.PlayerLogin);
            local content = EInputNickname.getText() + "&" + sha256(EInputPassword.getText());
            print(content.len());
            packet.writeString(content);
            packet.send(RELIABLE_ORDERED); // sending packet with RELIABLE_ORDERED reliability to server
            print("Packet sent");
            //EButtonLogin.setDisabled(true);
            break;
    }
})

addEventHandler("GUI.onMouseIn", function(self) {
    if (!(self instanceof GUI.Button)) return

    self.setColor(255, 0, 0)
})

addEventHandler("GUI.onMouseOut", function(self) {
    if (!(self instanceof GUI.Button)) return

    self.setColor(255, 255, 255)
})

addEventHandler("GUI.onInputInsertLetter", function(element, text) {
});

addEventHandler("GUI.onInputRemoveLetter", function(element, letter) {
});

addEventHandler("GUI.onInputActive", function(element) {
});

addEventHandler("GUI.onInputDeactive", function(element) {
});


