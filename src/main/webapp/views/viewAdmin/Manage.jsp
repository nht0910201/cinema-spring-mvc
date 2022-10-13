<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="m1" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="products" scope="request" type="java.util.List<com.hcmute.bookstore.models.Product>"/>
<jsp:useBean id="users" scope="request" type="java.util.List<com.hcmute.bookstore.models.User>"/>
<jsp:useBean id="categories" scope="request" type="java.util.List<com.hcmute.bookstore.models.Category>"/>
<jsp:useBean id="sub_categories" scope="request" type="java.util.List<com.hcmute.bookstore.models.Category>"/>
<m1:Admin>
    <jsp:attribute name="js">
         <script>
             $(document).ready(function () {
                 $('.t1').after('<div id="nav1" class="text-center mt-2 mb-2"></div>');
                 let itemsShown = 1;
                 let itemsTotal = $('.t1 .item1').length;
                 let numPages = itemsTotal / itemsShown;
                 for (let i = 0; i < numPages; i++) {
                     let pageNum = i + 1;
                     $('#nav1').append('<a href="#" class="btn-outline-info btn-sm text-decoration-none rounded-lg border border-warning" rel="' + i + '">&emsp;' + pageNum + '&emsp;</a> ');
                 }
                 $('.t1 .item1').hide();
                 $('.t1 .item1').slice(0, itemsShown).show();
                 $('#nav1 a:first').addClass('active');
                 $('#nav1 a').bind('click', function (e) {
                     e.preventDefault();
                     $('#nav1 a').removeClass('active');
                     $(this).addClass('active');
                     let currPage = $(this).attr('rel');
                     let startItem = currPage * itemsShown;
                     let endItem = startItem + itemsShown;
                     $('.t1 .item1').css('opacity', '0').hide().slice(startItem, endItem).css('display', 'block').animate({
                         opacity: 1
                     }, 300);
                 });
             });
             function removeUser(url) {
                 $.getJSON(url, function (data) {
                     if (data === false) {
                         swal({
                             title: "Error!",
                             text: "Xoá tài khoản người dùng không thành công",
                             icon: "error",
                             button: "OK!",
                             dangerMode: true,
                             closeOnClickOutside: false,
                         });
                     } else {
                         swal({
                             title: "Successfully",
                             text: "Xoá tài khoản người dùng thành công",
                             icon: "success",
                             button: "OK!",
                             closeOnClickOutside: false,
                         })
                             .then(function () {
                                     location.reload();
                                 }
                             );
                     }
                 });
             }
             function removeCategory(url) {
                 $.getJSON(url, function (data) {
                     if (data === false) {
                         swal({
                             title: "Error!",
                             text: "Category đang có sản phẩm hoặc có Category cấp nhỏ hơn",
                             icon: "error",
                             button: "OK!",
                             dangerMode: true,
                             closeOnClickOutside: false,
                         });
                     } else {
                         swal({
                             title: "Successfully",
                             text: "Xoá tài Category thành công",
                             icon: "success",
                             button: "OK!",
                             closeOnClickOutside: false,
                         })
                             .then(function () {
                                     location.reload();
                                 }
                             );
                     }
                 });
             }
             function handleProductClick() {
                 $('#btnProduct').removeClass('btn-outline-danger')
                 $('#btnProduct').addClass('btn-danger')
                 $('#products').removeAttr('hidden')

                 $('#btnUser').removeClass('btn-primary')
                 $('#btnUser').addClass('btn-outline-primary')
                 $('#users').attr('hidden', true)

                 $('#btnCategory').removeClass('btn-warning')
                 $('#btnCategory').addClass('btn-outline-warning')
                 $('#category').attr('hidden', true)
             }

             function handleUserClick() {
                 $('#btnUser').removeClass('btn-outline-primary')
                 $('#btnUser').addClass('btn-primary')
                 $('#users').removeAttr('hidden')

                 $('#btnProduct').removeClass('btn-danger')
                 $('#btnProduct').addClass('btn-outline-danger')
                 $('#products').attr('hidden', true)

                 $('#btnCategory').removeClass('btn-warning')
                 $('#btnCategory').addClass('btn-outline-warning')
                 $('#category').attr('hidden', true)
             }
             function hanldeCategoryClick(){
                 $('#btnCategory').removeClass('btn-outline-warning')
                 $('#btnCategory').addClass('btn-warning')
                 $('#category').removeAttr('hidden')

                 $('#btnProduct').removeClass('btn-danger')
                 $('#btnProduct').addClass('btn-outline-danger')
                 $('#products').attr('hidden', true)

                 $('#btnUser').removeClass('btn-primary')
                 $('#btnUser').addClass('btn-outline-primary')
                 $('#users').attr('hidden', true)
             }
         </script>
    </jsp:attribute>
    <jsp:body>
        <div class="col-sm-12 mt-1 p-0">
            <div class="w-100 bg-light d-flex justify-content-center">
                <button id="btnUser" onclick="handleUserClick()" class="btn btn-primary mr-3" role="button">
                    <i class="fa fa-user" aria-hidden="true"></i>
                    User
                </button>
                <button id="btnCategory" onclick="hanldeCategoryClick()" class="btn btn-outline-warning mr-3" role="button">
                    <i class="fa fa-bars" aria-hidden="true"></i>
                    Category
                </button>
                <button id="btnProduct" onclick="handleProductClick()" class="btn btn-outline-danger mr-3"
                        role="button">
                    <i class="fa fa-product-hunt" aria-hidden="true"></i>
                    Product
                </button>
                <button id="btnOrder" class="btn btn-outline-success" role="button">
                    <i class="fa fa-shopping-bag" aria-hidden="true"></i>
                    Order
                </button>
            </div>
<%--            User--%>
            <div id="users" class="container mt-3">
                <div class="d-flex justify-content-between">
                    <h3>User</h3>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/add_user" role="button">
                        Add User
                        <i class="fa fa-plus" aria-hidden="true"></i>
                    </a>
                </div>
                <div class="mt-3">
                    <table class="table">
                        <thead>
                        <tr>
                            <th scope="col">No.</th>
                            <th scope="col">Name</th>
                            <th scope="col">Email</th>
                            <th scope="col">Phone</th>
                            <th scope="col">Role</th>
                            <th scope="col">State</th>
                            <th scope="col">Edit,Delete</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${users}" var="user" varStatus="loop">
                        <tr>
                            <td>${loop.index +1}</td>
                            <td>${user.name}</td>
                            <td>${user.email}</td>
                            <td>${user.phone}</td>
                            <td>${user.role}</td>
                            <td>${user.state}</td>
                            <td>
                                <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/update_user/${user.id}" role="button">
                                    <i class="fa fa-pencil" aria-hidden="true"></i>
                                </a>
                                <button type="button" onclick="removeUser('${pageContext.request.contextPath}/admin/delete_user/${user.id}')" class="btn btn-outline-danger">
                                    <i class="fa fa-trash" aria-hidden="true"></i>
                                </button>
                            </td>
                        </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
<%--            Category--%>
            <div id="category" class="container mt-3" hidden>
                <div class="d-flex justify-content-between">
                    <h3>Category</h3>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/add_category" role="button">
                        Add Category
                        <i class="fa fa-plus" aria-hidden="true"></i>
                    </a>
                </div>
                <div class="mt-3">
                    <table class="table">
                        <thead>
                        <tr>
                            <th scope="col">No.</th>
                            <th scope="col">Name</th>
                            <th scope="col">Parent Category</th>
                            <th scope="col">Edit,Delete</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${categories}" var="category" varStatus="loop">
                        <tr>
                            <td>${loop.index +1}</td>
                            <td>${category.name}</td>
                            <td>
                                <c:forEach items="${sub_categories}" var="sub_category">
                                    <c:if test="${category.parent_id == sub_category.id}">
                                        ${sub_category.name}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/update_category/${category.id}" role="button">
                                    <i class="fa fa-pencil" aria-hidden="true"></i>
                                </a>
                                <button type="button" onclick="removeCategory('${pageContext.request.contextPath}/admin/delete_category/${category.id}')" class="btn btn-outline-danger">
                                    <i class="fa fa-trash" aria-hidden="true"></i>
                                </button>
                            </td>
                        </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
<%--            Product--%>
            <div id="products" class="container mt-3" hidden>
                <div class="d-flex justify-content-between">
                    <h3>Product</h3>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/add_product"
                       role="button">Add Product
                        <i class="fa fa-plus" aria-hidden="true"></i>
                    </a>
                </div>
                <div class="d-flex flex-wrap t1">
                    <c:forEach items="${products}" var="product">
                        <div class="item1 card mx-auto" style="width: 15rem;">
                            <a href="${pageContext.request.contextPath}/admin/update_product/${product.id}">
                                <img src="${product.productImages.get(0).img_src}" class="card-img-top" alt="...">
                            </a>
                            <div class="card-body">
                                <h5 class="card-title">${product.name}</h5>
                                <p class="card-text" style="text-decoration-line: line-through">${product.price}</p>
                                <p class="card-text text-danger">${product.discount}%</p>
                                <p class="card-text font-weight-bold">${product.price-((product.price*product.discount)/100)}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </jsp:body>
</m1:Admin>