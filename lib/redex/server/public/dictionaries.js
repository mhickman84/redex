$(document).ready(function() {
    $('#sidebar a').click(function() {
        var navId = '#' + $(this).parents('ul').attr('id');
        var templateId = findTemplate(navId);
        var targetId = findTarget(navId);
        selectDictionary($(this));
        $.ajax({
            dataType: "json",
            url: $(this).attr('href'),
            jsonp: "$callback",
            success: function(dictItems) {
                $(targetId).empty();
                $(templateId).tmpl(dictItems).appendTo(targetId);
            }
        });
        return false;
    });
});