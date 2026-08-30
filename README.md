# Multi-ESP-Flasher

Công cụ CLI **flash liên tục (multi-flash)** cho nhiều thiết bị ESP32 với quy trình **chọn sản phẩm phần cứng** và **ghi nhớ lựa chọn file** cho từng sản phẩm.

| File            | Địa chỉ flash |
|-----------------|---------------|
| `bootloader.bin`  | `0x1000`    |
| `partitions.bin`  | `0x8000`    |
| `firmware.bin`    | `0x10000`   |
| `spiffs.bin`      | `0x290000`  |
| `combined.bin` (merged) | `0x0` (nguyên khối) |

Baud: `921600` — Chip: `esp32`. Trước khi flash, tool tự xóa vùng OTA boot data (`0xE000`).

---

## Cách chạy

- Bản portable: nhấp đúp **`bin\Multi-ESP-Flasher.exe`** (không cần cài Python).
- Bản script: nhấp đúp **`Multi-ESP-Flasher.bat`** (cần Python 3 + `pip install esptool pyserial`).

## Quy trình

- **ĐANG KIỂM TRA ESP-TOOL-CLI** — kiểm tra ngầm; nếu OK vào thẳng BƯỚC 1 (không đếm ngược).

### BƯỚC 1 — Chọn sản phẩm phần cứng
- Tool **quét các THƯ MỤC CON cùng cấp với file exe** (các thư mục nằm trong cùng thư mục chứa exe) và hiển thị danh sách sản phẩm.
- Chọn bằng phím **↑/↓**, **Enter** chọn, **ESC** đóng ứng dụng, **R/F5** quét lại.

### BƯỚC 2 — Chọn lần lượt các file bin cho sản phẩm
- Chọn **từng loại một**: `bootloader.bin`, `partitions.bin`, `firmware.bin`, `spiffs.bin` + mục thứ 5 là **`combined.bin`** (file gộp/merged).
- Tool **tự phát hiện** file bin có sẵn trong thư mục sản phẩm và **ghi nhớ lựa chọn** vào file **`Multi-ESP-Flasher.db.txt`** (đặt cạnh exe).
- Mở lại ứng dụng sẽ **nạp lại** lựa chọn đã nhớ; nếu thư mục sản phẩm không còn tồn tại thì db được cập nhật (xóa mục cũ).
- Nếu chọn `combined.bin` → flash nguyên khối tại `0x0`; nếu không → flash 4 file theo offset riêng.

### BƯỚC 3 — Chọn chế độ
- `a)` **Auto multi flash** — sau khi flash, tự phát hiện cổng COM online và flash tiếp.
- `b)` **Confirm multi flash** — sau khi flash, đợi nhấn **Enter** để flash tiếp / **ESC** thoát.

### BƯỚC 4 — Quét & chọn cổng COM
- **↑/↓** chọn, **R/F5** quét lại, **Enter** chọn, **ESC** đóng ứng dụng.

### BƯỚC 5 — Vòng lặp flash
- **Auto:** flash xong → chờ rút/cắm USB → **đếm ngược 5s chống debounce** → tự flash tiếp; ESC thoát ngoài lúc flash; không thoát khi đang flash.
- **Confirm:** flash xong → **Enter** flash tiếp / **ESC** thoát.

### BƯỚC 6 — Báo cáo
- Hiển thị **`Số board đã nạp: XXX`** (to + đậm + đỏ) + dòng `Lỗi:` nếu có.
- Nhấn **Enter** hoặc **ESC** để đóng cửa sổ.

---

## File portable & đóng gói

- Exe: **`bin\Multi-ESP-Flasher.exe`** — bundle sẵn Python + esptool + pyserial + tkinter, chạy không cần cài gì.
- Toàn bộ **code tool** (build, splash, spec) nằm trong `.vscode\` (đã thêm vào `.gitignore`).
- Đóng gói lại sau khi sửa code: `.vscode\BUILD-PORTABLE.bat`.

### Dùng trên máy mới
- Không cần cài Python/esptool (exe bundle sẵn).
- Cần **driver USB-serial** của board (CH340/CP210x) nếu máy mới chưa có — không sẽ không thấy cổng COM.
- Exe không ký số → SmartScreen cảnh báo thì bấm *More info → Run anyway*.
- **Lưu ý quét sản phẩm:** ứng dụng quét các **thư mục con nằm trong cùng thư mục chứa file exe** (ví dụ exe ở `bin\MLAstro-Multi-ESP-Flasher.exe` → quét các thư mục bên trong `bin\`). Muốn thêm sản phẩm, chỉ cần tạo thư mục trong cùng thư mục exe và đặt các file bin vào đó.
