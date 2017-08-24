function include_validators() {
    sign_in_validators();
    sign_up_validators();
}

function sign_in_validators() {
    $("#user_email").focusout(function () {
        check_field($(this), [valid_email]);
    });
    $("#user_password").focusout(function () {
        check_field($(this), [valid_password]);
    });
    // $("#sign_in_submit").click(function () {
    //     email = check_field($("#user_email"), [blank_field, valid_email]);
    //     password = check_field($("#user_password"), [blank_field, valid_password]);
    //     return email && password;
    // });
}

function sign_up_validators() {
    $("#user_email").focusout(function () {
        check_field($(this), [valid_email]);
    });
    $("#user_password").focusout(function () {
        check_field($(this), [valid_password]);
    });
    $("#user_name").focusout(function () {
        check_field($(this), [valid_name]);
    });
    $("#user_password_confirmation").focusout(function () {
        check_field($(this), [valid_password_confirmation]);
    });
    // $("#sign_up_submit").click(function () {
    //     name = check_field($("#user_name"), [blank_field, valid_name]);
    //     email = check_field($("#user_email"), [blank_field, valid_email]);
    //     password = check_field($("#user_password"), [blank_field, valid_password]);
    //     password_confirmation = check_field($("#user_password_confirmation"),
    //                                         [blank_field, valid_password_confirmation]);
    //     return name && email && password && password_confirmation;
    // });
}


function valid_name(val) {
    var regex = new RegExp('^[A-Za-z]+ [A-Za-z]+$');
    if (!regex.test(val))
        return 'invalid name';
    else
        return '';
}

function valid_email(val) {
    var regex = new RegExp('^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');
    if (!regex.test(val))
        return 'invalid email';
    else
        return '';
}

function valid_password(val) {
    if (val.length <= 5)
        return 'is too short (minimum is 6 characters)';
    else
        return '';
}

function valid_password_confirmation(val) {
    var confirmed_val = $("#user_password").val();
    if (val != confirmed_val)
        return 'invalid password confirmation';
    else
        return '';
}

function blank_field(val) {
    if (val.length === 0)
        return "can't be blank";
    else
        return '';
}

function check_field(field, validators) {
    var value = $(field).val(),
        message = '';
    remove_error($(field));
    if(value.length === 0){
        return false;
    }
    for (i = 0; i < validators.length; i++) {
        message = validators[i](value);
        if (message.length > 0) {
            add_error($(field), message);
            return false;
        }
    }
    return true;
}

function add_error(field, message){
    var input_group = $(field).parent().parent();
    $(input_group).addClass('has-error');
    $(field).after("<span class='help-block'>" + message + "</span>");
}

function remove_error(field){
    var input_group = $(field).parent().parent();
    $(input_group).removeClass('has-error');
    $(field).parent().find('span').remove();
}