var children = []

function cleanup()
{
    var length = children.length;

    for (var i = 0; i < length; i++) {
        var item = children[i];

        item.widthChanged.disconnect(relayout);
        item.heightChanged.disconnect(relayout);
        item.visibleChanged.disconnect(relayout);
    }

    children = [];
}

function updateChildren()
{
    cleanup();

    var length = row.children.length;

    for (var i = 0; i < length; i++) {
        var item = row.children[i];

        item.widthChanged.connect(relayout);
        item.heightChanged.connect(relayout);
        item.visibleChanged.connect(relayout);

        children.push(item);
    }

    relayout();
}

function relayout()
{
    var ix = 0;
    var ih = 0;

    var length = children.length;

    for (var i = 0; i < length; i++) {
        var item = children[i];

        if (!item.visible)
            continue;

        item.x = ix;
        item.y = 0;
        ih = Math.max(ih, item.height);
        ix += item.width;
    }

    row.width = ix;
    row.height = ih;
}
