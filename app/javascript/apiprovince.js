const host = "https://provinces.open-api.vn/api/";

var callAPI = (api) => {
  return axios.get(api)
    .then((response) => {
      renderData(response.data, "province");
    })
    .catch((error) => {
      console.error("Error fetching provinces:", error);
    });
};

var callApiDistrict = (api) => {
  return axios.get(api)
    .then((response) => {
      renderData(response.data.districts, "district");
    })
    .catch((error) => {
      console.error("Error fetching districts:", error);
    });
};

var callApiWard = (api) => {
  return axios.get(api)
    .then((response) => {
      renderData(response.data.wards, "ward");
    })
    .catch((error) => {
      console.error("Error fetching wards:", error);
    });
};

var renderData = (array, select) => {
  let row = '<option value="">Chọn</option>'; // Tùy chọn mặc định
  array.forEach(element => {
    row += `<option data-id="${element.code}" value="${element.name}">${element.name}</option>`;
  });
  document.querySelector("#" + select).innerHTML = row;
};

// Sự kiện thay đổi danh sách tỉnh/thành
document.querySelector("#province").addEventListener("change", () => {
  const provinceId = document.querySelector("#province").selectedOptions[0].getAttribute("data-id");
  if (provinceId) {
    callApiDistrict(host + "p/" + provinceId + "?depth=2");
  }
});

// Sự kiện thay đổi danh sách quận/huyện
document.querySelector("#district").addEventListener("change", () => {
  const districtId = document.querySelector("#district").selectedOptions[0].getAttribute("data-id");
  if (districtId) {
    callApiWard(host + "d/" + districtId + "?depth=2");
  }
});

// Gọi API để lấy danh sách tỉnh/thành khi tải trang
callAPI(host + "?depth=1");
