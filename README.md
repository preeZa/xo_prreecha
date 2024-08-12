# แอพเกม XO (Tic-Tac-Toe) ด้วย Flutter

แอพพลิเคชัน Flutter สำหรับเล่นเกม Tic-Tac-Toe ที่คลาสสิก แอพนี้มีโหมดการเล่นสองโหมด: โหมดผู้เล่น 2 คน และโหมด AI(Minimax Algorithm ใช้เฉพาะ 3x3 alpha beta pruning algorithm 4x4 ขึ้นไป) ผู้ใช้สามารถเลือกขนาดของกระดานได้ทั้งสองโหมด

## ฟีเจอร์

- **โหมดการเล่นสองโหมด:**
  - **โหมดผู้เล่น 2 คน:** เล่นกับผู้เล่นคนอื่นในจอเดียวกัน
  - **โหมด AI:** เล่นกับ AI ทีมีความยากไม่มาก 

- **ขนาดกระดานที่ปรับได้:**
  - เลือกขนาดกระดานที่กำหนดไว้ล่วงหน้า: 3x3, 4x4, 5x5, และ 6x6 หรือ กำหนดขนาดกระดานเอง(กรอกแค่ตัวเลขตัวเดียวนะครับ)
  - ไม่รองรับขนาดที่มากกว่า 20*20 เนื่องจาก มีจำนวนตารางมากเกินไปจึงทำให้มองไม่เห็นได้ชัด

- **ดูประวัติกระดานย้อนหลังได้**
    - สามารถดูประวัติย้อนหลังของ 2 player ได้ (2 Player --> icon history ด้านบนขวา)
    - สามารถดูประวัติย้อนหลังของ Ai ได้ ( Ai --> icon history ด้านบนขวา)
    - สามารถดูได้ทั้งแบบ รวม หรือ คลิกที่ Card ก็จะแสดงข้อมูลั้งหมดของเกมนั้น

  ## การติดตั้ง 
    - ขั้นตอนแรกทำการ clone project นี้ลงบนอุปกรณ์ 
    - ขั้นตอนต่อมา เปิด terminal ขึ้นมาแล้ว ใช้คำสั่ง flutter pub get เพื่อทำการลงตัว library ที่จำเป็นต่อตัว project นี้ (ตรวจสอบ path ของ terminal ให้อยุ่ตำแหน่งของ project นี้ ก่อนพิมพ์คำสั่ง)
    - ขั้นตอนต่อมา ให้เปิดตัว emulator หรือ เชื่อมต่อผ่าน โทรศัพท์ (รองรับแค่ Android)
    - ขั้นตอนต่อมา หาไฟล์ที่ชื่อ lib แล้วไปที่ main.dart จากนั้นใช้เมาส์เลื่อนไปที่ Future<void> main() จะมี run | debug | profile ให้คลิกไปที่ run จากนั้นรอสักครู่ให้ตัวโปรแกรมทำงาน (ถ้าไม่มี ให้ไปที่ terminal แล้วใช้คำสั่งนี้ flutter run)
