# RoV Mod Patch (1.64.1)

แพตช์ mod สำหรับเกม **RoV / Realm of Valor (ไทย)** เวอร์ชัน **1.64.1** — สร้างจากเครื่องมือ Lua53

## โครงสร้าง patch

```
RoV-Mod/
└── com.garena.game.kgth/          ← bundle ID ของเกม RoV ไทย
    └── Documents/
        └── Resources/
            └── 1.64.1/            ← ตำแหน่งไฟล์ใน app container ของเกม
                ├── KernelLua.pkg.bytes          (ข้ามตรวจ CRC/Hash แก้ค้าง 86%)
                ├── StableSystems_3.pkg.bytes    (ล็อก UID + ข้อความลิขสิทธิ์ล็อบบี้)
                ├── PlayerInfoLua.pkg.bytes      (โปรไฟล์/ล็อกข้าม)
                ├── HeroInfoLua.pkg.bytes        (ใส่สกิน/ปุ่มใส่ชุด)
                ├── GameVip.pkg.bytes            (VIP 10 + ร้าน VIP)
                └── Customization.pkg.bytes      (ปรับแต่งตัวละคร/สกิน)
```

## วิธีใช้กับแอป 3105 (RoV edition)

1. เปิดแอป **3105** บน iPhone → แท็บ **Patch** → กด **+** → **New Patch**
2. ตั้งชื่อโปรเจกต์ (เช่น `RoV-Mod`) และระบุ **bundle identifier** = `com.garena.game.kgth`
3. เปิด **Files → 3105 Workspace → Patches → RoV-Mod → com.garena.game.kgth**
4. สร้างโฟลเดอร์ `Documents/Resources/1.64.1/` แล้ววางไฟล์ `.pkg.bytes` ทั้ง 6 ไฟล์ลงไป
   (หรือคัดลอกโครงสร้างทั้งโฟลเดอร์ `com.garena.game.kgth` จากที่นี่ไปวางแทน)
5. กลับไปที่ patch แล้วกด **Apply** → 3105 จะสำรองไฟล์เดิมและเขียนไฟล์ mod ลงเกม
6. (ไม่บังคับ) กด **Export** เพื่อแพ็กเป็นไฟล์ `.3105` สำหรับแจกจ่าย

## ข้อควรรู้

- ต้องใช้กับเกม RoV ไทยเวอร์ชัน **1.64.1** (ตรงกับโฟลเดอร์ `1.64.1/`)
- ปิดเกมให้สนิทก่อน Apply
- แพตช์นี้เป็นไฟล์ **build ปกติ** (ไม่มี manifest/signature) — ถ้าต้องการชุดแบบ
  เข้ารหัส + เซ็นลายเซ็น ให้ใช้ `Lua53: build all --protect` แล้วได้ 8 ไฟล์
- สำรองข้อมูลเกมก่อนใช้ทุกครั้ง
