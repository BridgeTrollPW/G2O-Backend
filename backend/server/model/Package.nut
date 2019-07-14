class Package {
    id = null;
    name = null;
    callback = null;

    constructor(packageId, packageName, eventCallback) {
        id = packageId;
        name = packageName;
        callback = eventCallback;
    }
}