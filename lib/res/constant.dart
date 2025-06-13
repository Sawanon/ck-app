class AppConst {
  static const String cloudfareUrl = "http://demo.mylaos.life:3000";
  static String apiUrl = "https://demo.mylaos.life/api";
  static String apiInviteFriends = "https://demo.mylaos.life/api/invite-friend";
  // static String apiInviteFriends = "http://192.168.1.157:3001/api";

  static String videoUrl = "10.101.23.10:3000/api";

  // authorization
  static const String publicToken =
      "SI+TPTYs7D+aAR5/PJHZBUBBiAFQt69RsstvJ40OeL6aOXtz4kC88PrOuJ9rxJlA";
  static const String secret =
      "0zpyT187AS7ebvGTnY3OHEA46imQs9M5CEGE7v4/VCKyiDH1SJLyQcg9dlcNW329";

  // app version
  static const String appVersion = "1.1";

  // appwrite
  static const String endPoint = "https://baas.moevedigital.com/v1";
  static const String appwriteProjectId = "667afb24000fbd66b4df";

  // zz
  static const String secretZZ = "sHib5ycSalFybq6dhFdmvmQSw82+fj/nhhLM0sAPVqs=";

  // production
  // https://daily.horodd.win/?payload=<token>
  // static const String horoScopeUrl = "https://daily.horodd.win/?payload=";

  // staging
  // static const String horoScopeUrl =
  //     "https://staging.daily-ce2.pages.dev/?payload=";
  static const String horoScopeUrl = "https://demo.mylaos.life/daily/?payload=";

  // production
  // https://randomcards.horodd.win/?payload=<token>
  // static const String randomCardUrl =
  //     "https://randomcards.horodd.win/?payload=";

  // staging
  // static const String randomCardUrl =
  //     "https://staging.randomcards.pages.dev/?payload=";
  static const String randomCardUrl =
      "https://demo.mylaos.life/randomcards/?payload=";

  static const animalDatas = [
    {
      "name": "ปลาน้อย",
      "th": "ปลาน้อย",
      "lo": "ປານ້ອຍ",
      "en": "Little Fish",
      "key": "smallFish",
      "image": "fish.png",
      "lotteries": ["01", "41", "81"],
    },
    {
      "name": "หอย",
      "th": "หอย",
      "lo": "ຫອຍ",
      "en": "Snail",
      "image": "shell.png",
      "lotteries": ["02", "42", "82"],
    },
    {
      "name": "ห่าน",
      "th": "ห่าน",
      "lo": "ຫ່ານ",
      "en": "Goose",
      "image": "goose.png",
      "lotteries": ["03", "43", "83"],
    },
    {
      "name": "นกยูง",
      "th": "นกยูง",
      "lo": "ນົກຢູງ",
      "en": "Peacock",
      "image": "peacock.png",
      "lotteries": ["04", "44", "84"],
    },
    {
      "name": "สิงโต",
      "th": "สิงโต",
      "lo": "ສິງ",
      "en": "Lion",
      "image": "lion.png",
      "lotteries": ["05", "45", "85"],
    },
    {
      "name": "เสือ",
      "th": "เสือ",
      "lo": "ເສືອ",
      "en": "Tiger",
      "image": "tiger.png",
      "lotteries": ["06", "46", "86"],
    },
    {
      "name": "หมู",
      "th": "หมู",
      "lo": "ໝູ",
      "en": "Pig",
      "image": "pig.png",
      "lotteries": ["07", "47", "87"],
    },
    {
      "name": "กระต่าย",
      "th": "กระต่าย",
      "lo": "ກະຕ່າຍ",
      "en": "Rabbit",
      "image": "rabbit.png",
      "lotteries": ["08", "48", "88"],
    },
    {
      "name": "ควาย",
      "th": "ควาย",
      "lo": "ຄວາຍ",
      "en": "Buffalo",
      "image": "buffalo.png",
      "lotteries": ["09", "49", "89"],
    },
    {
      "name": "นาก",
      "th": "นาก",
      "lo": "ນາກນ້ໍາ",
      "en": "Otter",
      "image": "otter.png",
      "lotteries": ["10", "50", "90"],
    },
    {
      "name": "หมา",
      "th": "หมา",
      "lo": "ໝາ",
      "en": "Dog",
      "image": "dog.png",
      "lotteries": ["11", "51", "91"],
    },
    {
      "name": "ม้า",
      "th": "ม้า",
      "lo": "ມ້າ",
      "en": "Horse",
      "image": "horse.png",
      "lotteries": ["12", "52", "92"],
    },
    {
      "name": "ช้าง",
      "th": "ช้าง",
      "lo": "ຊ້າງ",
      "en": "Elephant",
      "image": "elephant.png",
      "lotteries": ["13", "53", "93"],
    },
    {
      "name": "แมวบ้าน",
      "th": "แมวบ้าน",
      "lo": "ແມວບ້ານ",
      "en": "Domestic Cat",
      "image": "cat.png",
      "lotteries": ["14", "54", "94"],
    },
    {
      "name": "หนู",
      "th": "หนู",
      "lo": "ໜູ",
      "en": "Rat",
      "image": "rat.png",
      "lotteries": ["15", "55", "95"],
    },
    {
      "name": "ผึ้ง",
      "th": "ผึ้ง",
      "lo": "ເຜິ້ງ",
      "en": "Bee",
      "image": "bee.png",
      "lotteries": ["16", "56", "96"],
    },
    {
      "name": "นกกระยาง",
      "th": "นกกระยาง",
      "lo": "ນົກຍາງ",
      "en": "Egret",
      "image": "egret.png",
      "lotteries": ["17", "57", "97"],
    },
    {
      "name": "แมวป่า",
      "th": "แมวป่า",
      "lo": "ແມວປ່າ",
      "en": "Wild Cat",
      "image": "catforest.png",
      "lotteries": ["18", "58", "98"],
    },
    {
      "name": "ผีเสื้อ",
      "th": "ผีเสื้อ",
      "lo": "ກະເບື້ອ",
      "en": "Butterfly",
      "image": "butterfly.png",
      "lotteries": ["19", "59", "99"],
    },
    {
      "name": "ตะขาบ",
      "th": "ตะขาบ",
      "lo": "ຂີ້ເຂັບ",
      "en": "Centipede",
      "image": "centipede.png",
      "lotteries": ["00", "20", "60"],
    },
    {
      "name": "นกนางแอ่น",
      "th": "นกนางแอ่น",
      "lo": "ນົກແອ່ນ",
      "en": "Swallow",
      "image": "swallow2.png",
      "lotteries": ["21", "61"],
    },
    {
      "name": "นกแกนแก",
      "th": "นกแกนแก",
      "lo": "ແຫຼວ",
      "en": "Pigeon",
      "image": "birdgangare.png",
      // "lotteries": ["92", "51", "21"],
      "lotteries": ["22", "62"],
    },
    {
      "name": "ลิง",
      "th": "ลิง",
      "lo": "ລິງ",
      "en": "Monkey",
      "image": "monkey.png",
      "lotteries": ["23", "63"],
    },
    {
      "name": "กบ",
      "th": "กบ",
      "lo": "ກົບ",
      "en": "Frog",
      "image": "fog.png",
      "lotteries": ["24", "64"],
    },
    {
      "name": "เหยี่ยว",
      "th": "เหยี่ยว",
      "lo": "ເຫຍີ່ວ",
      "en": "Hawk",
      "image": "hawk.png",
      "lotteries": ["25", "65"],
    },
    {
      "name": "มังกร",
      "th": "มังกร",
      "lo": "ນາກບິນ",
      "en": "Dragon",
      "image": "dragon.png",
      "lotteries": ["26", "66"],
    },
    {
      "name": "เต่า",
      "th": "เต่า",
      "lo": "ເຕົ່າ",
      "en": "Turtle",
      "image": "turtle.png",
      "lotteries": ["27", "67"],
    },
    {
      "name": "ไก่",
      "th": "ไก่",
      "lo": "ໄກ່",
      "en": "Chicken",
      "image": "chicken.png",
      "lotteries": ["28", "68"],
    },
    {
      "name": "ปลาไหล",
      "th": "ปลาไหล",
      "lo": "ອ່ຽນ",
      "en": "Eel",
      "image": "eel.png",
      "lotteries": ["29", "69"],
    },
    {
      "name": "ปลาใหญ่",
      "th": "ปลาใหญ่",
      "lo": "ປາໃຫຍ່",
      "en": "Big Fish",
      "image": "bigfish.png",
      "lotteries": ["30", "70"],
    },
    {
      "name": "กุ้ง",
      "th": "กุ้ง",
      "lo": "ກຸ້ງ",
      "en": "Shrimp",
      "image": "shrimp.png",
      "lotteries": ["31", "71"],
    },
    {
      "name": "งู",
      "th": "งู",
      "lo": "ງູ",
      "en": "Snake",
      "image": "snake.png",
      "lotteries": ["32", "72"],
    },
    {
      "name": "แมงมุม",
      "th": "แมงมุม",
      "lo": "ແມງມຸມ",
      "en": "Spider",
      "image": "spiderman.png",
      "lotteries": ["33", "73"],
    },
    {
      "name": "กวาง",
      "th": "กวาง",
      "lo": "ກວາງ",
      "en": "Deer",
      "image": "deer.png",
      "lotteries": ["34", "74"],
    },
    {
      "name": "แพะ",
      "th": "แพะ",
      "lo": "ແບ້",
      "en": "Goat",
      "image": "goat.png",
      "lotteries": ["35", "75"],
    },
    {
      "name": "อีเห็น",
      "th": "อีเห็น",
      "lo": "ເຫງັນ",
      "en": "Weasel",
      "image": "weasel.png",
      "lotteries": ["36", "76"],
    },
    {
      "name": "ตัวนิ่ม",
      "th": "ตัวนิ่ม",
      "lo": "ລິ່ນ",
      "en": "Armadillo",
      "image": "armadillo.png",
      "lotteries": ["37", "77"],
    },
    {
      "name": "เม่น",
      "th": "เม่น",
      "lo": "ເໝັ້ນ",
      "en": "Porcupine",
      "image": "porcupine.png",
      "lotteries": ["38", "78"],
    },
    {
      "name": "ปู",
      "th": "ปู",
      "lo": "ປູ",
      "en": "Crab",
      "image": "crab.png",
      "lotteries": ["39", "79"],
    },
    {
      "name": "อินทรี",
      "th": "อินทรี",
      "lo": "ນົກອິນຊີ",
      "en": "Eagle",
      "image": "eagle.png",
      "lotteries": ["40", "80"],
    },
  ];

  static const String pubNubSubscribeKeyBCEL =
      'sub-c-91489692-fa26-11e9-be22-ea7c5aada356';
  static const String pubNubUserIdBCEL = 'BCELBANK';
  static const String mcid = "mch683532dad883b";
}
