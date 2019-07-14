class ResolutionUtils {
    function getScreenCenter() {
        local res = getResolution();

        return {
            x = (res.x / 2),
            y = (res.y / 2)
        };
    }

    function getCenterXY(width, height) {
        local center = getScreenCenter();
        return {
            x = (center.x - (width / 2)),
            y = (center.y - (height / 2))
        };
    }
}