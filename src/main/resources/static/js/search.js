function Found (url) {
    find = $('#search').val();
    if (find === '') {
        alert('Please enter a valid value');
    } else {
        location.href = url + "/search/query?search=" + find;
    }
}
