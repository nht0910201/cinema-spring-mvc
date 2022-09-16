<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="m1" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--<jsp:useBean id="user" scope="request" type="com.hcmute.bookstore.models.User"/>--%>
<m1:Auth>
    <jsp:attribute name="css">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    </jsp:attribute>
    <jsp:attribute name="js">
        <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
        <script>
            const oldEmail = $('#updateEmail').val();
            console.log('Old: ' + oldEmail)

            function handleChange() {
                let newEmail = $('#updateEmail').val()
                console.log(newEmail)
                if (oldEmail !== newEmail) {
                    $('#btnOTP').removeAttr('disabled')
                    $('#updateOtp').removeAttr('disabled')
                    $('#btnOTP').on('click', function () {
                        $('#btnOTP').html('<div class="spinner-grow text-primary" role="status"> <span class="sr-only">Loading...</span></div>');
                        if ($('#updateEmail').val() == 0) {
                            swal({
                                title: "Invalid email!",
                                text: "Please fill your valid email!",
                                icon: "warning",
                                button: "OK!",
                            });
                        } else {
                            const otp = $('#updateOtp').val();
                            const email = $('#updateEmail').val();
                            $.getJSON('${pageContext.request.contextPath}/auth/sendOTP?email=' + email + '&otp=' + otp, function (data) {
                                $('#btnOTP').html('OTP')
                                if (data === false) {
                                    swal({
                                        title: "Failed!",
                                        text: "Please click send OTP to your email again!",
                                        icon: "error",
                                        button: "OK!",
                                    });
                                } else swal({
                                    title: "Successfully!",
                                    text: "Your OTP has been sent to your email!",
                                    icon: "success",
                                    button: "OK!",
                                });
                            });
                        }
                    });
                    const email = $('#updateEmail').val();
                    const otp = $('#updateOtp').val();
                    if (otp !== '') {
                        $.getJSON('${pageContext.request.contextPath}/auth/sendOTP?email=' + email + '&otp=' + otp, function (otpData) {
                            if (otpData === false) {
                                swal({
                                    title: "Wrong OTP!",
                                    text: "Your OTP is invalid",
                                    icon: "error",
                                    button: "OK!",
                                    dangerMode: true,
                                    closeOnClickOutside: false,
                                });
                            } else {
                                $('#formRegister').off('submit').submit();
                            }
                        });
                    } else {
                        swal({
                            title: "Wrong OTP!",
                            text: "Your OTP is invalid. Please try again!",
                            icon: "error",
                            button: "OK!",
                            dangerMode: true,
                            closeOnClickOutside: false,
                        });
                        $('#formRegister').on('submit', function (e) {
                            e.preventDefault();
                            Validator({
                                form: '#formRegister',
                                formGroupSelector: '.form-group',
                                errorSelector: '.form-message',
                                rules: [
                                    Validator.isRequired('#updateOtp', 'Vui lòng nhập OTP'),
                                ],
                            });
                            $('#formRegister').off('submit').submit();
                        });
                    }

                } else {
                    $('#btnOTP').attr('disabled', true)
                    $('#updateOtp').attr('disabled', true)
                    $('#formRegister').on('submit', function (e) {
                        e.preventDefault();
                        Validator({
                            form: '#formRegister',
                            formGroupSelector: '.form-group',
                            errorSelector: '.form-message',
                            rules: [
                                Validator.isRequired('#updateName', 'Vui lòng nhập đầy đủ họ tên'),
                                Validator.isRequired('#updateDob', 'Vui lòng chọn ngày tháng năm sinh'),
                                Validator.isRequired('#updateEmail', 'Vui lòng nhập email'),
                                Validator.isRequired('#updatePhone', 'Vui lòng nhập số điện thoại'),
                                Validator.isEmail('#updateEmail', 'Vui lòng nhập email chính xác'),
                            ],
                        });
                        $('#formRegister').off('submit').submit();
                    });
                }
            }

            $(function () {
                $("#updateDob").datepicker();
            });
            $('updateName').select();
        </script>
    </jsp:attribute>
    <jsp:body>
        <div class="mx-auto col-lg-5 mt-lg-5">
            <form class="p-5 mx-auto border rounded-lg shadow bg-light" id="formRegister" method="post"
                  action="/user/update/${authUser.id}">
                    <%--                <div class="text-center mb-3">--%>
                    <%--                    <h3 class="text-primary" style="font-family: 'Russo One',sans-serif">--%>
                    <%--                        <b>PROFILE</b>--%>
                    <%--                    </h3>--%>
                    <%--                </div>--%>
                <div class="form-group d-flex justify-content-center">
                    <img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png"
                         class="rounded-circle" style="width: 150px;"
                         alt="Avatar"/>
                        <%--                    <input type="file" name="avatar" class="mx-auto" accept=".jpg,.png,.gif">--%>
                </div>
                <div class="form-group">
                    <input type="text" value="${authUser.name}" class="form-control" id="updateName" name="name"
                           aria-describedby="emailHelp">
                    <span class="form-message mx-auto text-danger"></span>
                </div>
                <div class="form-group">
                    <fmt:parseDate value="${authUser.dob}" pattern="yyyy-MM-dd" var="parsedDateTime" type="both"/>
                    <input type="text" value="<fmt:formatDate pattern="dd/MM/YYYY" value="${parsedDateTime}"/>"
                           class="form-control" id="updateDob"
                           name="dob">
                    <span class="form-message mx-auto text-danger"></span>
                </div>
                <div class="form-group">
                    <input type="text" value="${authUser.phone}" class="form-control" id="updatePhone" name="phone">
                    <span class="form-message mx-auto text-danger"></span>
                </div>
                <div class="form-group">
                    <div class="d-flex d-inline-block ">
                        <input type="email" value="${authUser.email}" class="form-control" id="updateEmail" name="email"
                               onchange="handleChange()">
                        <button type="button" class="btn btn-info ml-1" disabled id="btnOTP">OTP</button>
                    </div>
                    <span class="form-message mx-auto text-danger"></span>
                </div>
                <div class="form-group">
                    <input type="text" placeholder="OTP" name="otp" class="form-control" disabled id="updateOtp">
                    <span class="form-message mx-auto text-danger"></span>
                </div>
                    <%--                <hr class="w-100 mx-auto bg-primary">--%>
                <div class="d-flex justify-content-around">
                    <div class="text-center">
                        <a class="btn btn-outline-success" href="${pageContext.request.contextPath}/Home" role="button">
                            <i class="fa fa-home" aria-hidden="true"></i> Home
                        </a>
                    </div>
                    <div class="text-center">
                        <button type="submit" class="btn btn-primary w-100" id="btnSave">
                            Save Update
                            <i class="fa fa-floppy-o" aria-hidden="true"></i>
                        </button>
                    </div>
                    <div class="text-center">
                        <a id="btnChangePass" class="btn btn-outline-danger" href="#" role="button">
                            Change Password
                            <i class="fa fa-refresh" aria-hidden="true"></i>
                        </a>
                    </div>
                </div>
                <hr class="w-100 mx-auto bg-primary">
                <c:if test="${hasError}">
                    <div class="alert alert-danger alert-dismissible fade show w-75 mx-auto" role="alert">
                        <strong>Sign Up Fail: </strong> ${errorMessage}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                <c:if test="${hasNotify}">
                    <div class="alert alert-success alert-dismissible fade show w-75 mx-auto" role="alert">
                        <strong>Sign Up Fail: </strong> ${successMessage}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>

            </form>
        </div>
    </jsp:body>
</m1:Auth>