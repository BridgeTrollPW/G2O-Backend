local test = getScreenCenter();
print("X center" + test.x + " Y center " + test.y);

local WLoginPos = getCenterXY(400, 200);
local WLogin = GUI.Window(anx(WLoginPos.x), any(WLoginPos.y), anx(400), any(200), "MENU_INGAME.TGA", null, true);
const PADDING = 10;
/**
 *
 * ACHTUNG: ein Package String kann nur 101 Characters lang sein.
 * Bedeutet Nickname + Trennzeichen + Passwort dürfen zusammen höchstens 101 zeichen lang sein
 * Passwort wird wohl noch gehasht, also vorsicht
 *
 */
local ELabelNickname = GUI.Draw(anx(PADDING + 0), any(10), "Nickname", WLogin);
local EInputNickname = GUI.Input(anx(PADDING + 0), any(30), anx(300), any(25), "DLG_CONVERSATION.TGA", "FONT_OLD_20_WHITE_HI.TGA", Input.Text, Align.Left, "Dein Nickname", 0, WLogin);
EInputNickname.selector = "|";

local ELabelPassword = GUI.Draw(anx(PADDING + 0), any(70), "Password", WLogin);
local EInputPassword = GUI.Input(anx(PADDING + 0), any(90), anx(300), any(25), "DLG_CONVERSATION.TGA", "FONT_OLD_20_WHITE_HI.TGA", Input.Password, Align.Left, "Password", 0, WLogin);

local EButtonLogin = GUI.Button(anx(175), any(130), anx(50), any(25), "INV_SLOT_FOCUS.TGA", "Login", WLogin)

addEventHandler("onInit", function() {
    enableEvent_Render(true);
    enable_NicknameId(true);
    setCursorVisible(true);
    WLogin.setVisible(true);
    Camera.setPosition(13480.0, 1810.0, -1640.0);
    local CamPosition = Camera.getPosition();

    Camera.setRotation(0.0, 215.0, 0.0);
    local CamRotation = Camera.getRotation();

    Camera.enableMovement(false);
    Camera.modeChangeEnabled = false;
    showPlayerStatus(false);
});

addEventHandler("GUI.onClick", function(self) {
    switch (self) {
        case EButtonLogin:
            WLogin.setVisible(false);
            local ELabelLoading = GUI.Draw(anx(0), any(0), "Logging in ... Bitte warten", null);
            ELabelLoading.setVisible(true);
            packet <- Packet();
            packet.writeUInt8(Network.PackageTypes.Login);
            packet.writeString(params);

            packet.send(RELIABLE_ORDERED); // sending packet with RELIABLE_ORDERED reliability to server
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
    if (element == textInput) print(text);
});

addEventHandler("GUI.onInputRemoveLetter", function(element, letter) {
    if (element == textInput) print(letter);
});

addEventHandler("GUI.onInputActive", function(element) {
    if (element == textInput) print("Aktywowano");
});

addEventHandler("GUI.onInputDeactive", function(element) {
    if (element == textInput) print("Dezaktywowano");
});