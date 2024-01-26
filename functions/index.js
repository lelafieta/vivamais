/* eslint-disable require-jsdoc */
/* eslint-disable max-len */
/* eslint-disable no-unused-vars */
const axios = require("axios");
const functions = require("firebase-functions");
const admin = require("firebase-admin");

const serviceAccount = require("./maxalert-atm-mda-firebase.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://seu-projeto-firebase.firebaseio.com",
});

const db = admin.firestore();
const colectionUser = "users";
const apiUrl = "https://api.afrizona.com/api/atm/all";
let allAtmsGood = [];
let firebaseAtms = [];

// eslint-disable-next-line camelcase, require-jsdoc
function sendNotificationToDevice(deviceToken, atmName, atmSigitCode, moneyStatus, onlineStatus, mainStatus) {
  let status = "";
  const dataAtual = new Date();
  const dia = ("0" + dataAtual.getDate()).slice(-2);
  const mes = ("0" + (dataAtual.getMonth() + 1)).slice(-2);
  const ano = dataAtual.getFullYear();
  const horas = ("0" + dataAtual.getHours()).slice(-2);
  const minutos = ("0" + dataAtual.getMinutes()).slice(-2);
  const segundos = ("0" + dataAtual.getSeconds()).slice(-2);

  const formattedDate = `${dia}/${mes}/${ano} ${horas}:${minutos}:${segundos}`;

  if (onlineStatus == "" && moneyStatus != "") {
    status = `ATM: ${atmName}\nDinheiro: ${moneyStatus}\nEstado: ${formattedDate}`;
  } else if (onlineStatus != "" && moneyStatus == "") {
    status = `ATM: ${atmName}\nEstado: ${onlineStatus}\nEstado: ${formattedDate}`;
  } else if (onlineStatus != "" && moneyStatus != "") {
    status = `ATM: ${atmName}\nDinheiro: ${moneyStatus}\nEstado: ${formattedDate}`;
  } else {
    status = `ATM: ${atmName}\nAnomalia Resolvida\nDesde: ${moneyStatus}\nEstado: ${formattedDate}`;
  }

  const message = {
    token: deviceToken,
    notification: {
      title: "Atualização de ATM",
      body: status,
    },
    data: {
      click_action: "FLUTTER_NOTIFICATION_CLICK",
      screen_name: "AtmDetailsScreen",
      atm_id: atmSigitCode,
    },
  };

  // Envia a mensagem
  admin.messaging().send(message)
      .then((response) => {
        console.log("Notificação enviada com sucesso:", response);
      })
      .catch((error) => {
        console.error("Erro ao enviar notificação:", error);
      });
}

// eslint-disable-next-line camelcase, require-jsdoc
// function getFirebaseData(dataUser) {
//   dataUser.atms.forEach((doc) => {
//     firebaseAtms.push(doc);
//   });
// }

function getFirebaseData(dataUser) {
  let contador = 0;
  // console.log(dataUser.atms.length);

  dataUser.atms.forEach(async (doc) => {
    if (doc.estado_dinheiro == "" && doc.estado_online == "") {
      sendNotificationToDevice(dataUser.device_id, doc.nome, doc.atm_id.toString(), doc.estado_dinheiro, doc.estado_online, 1);
      contador++;
      // await db.collection(colectionUser).doc(dataUser.user_id).get().then((doc2)=>{

      //   console.log(doc2.data().atms);
      // });


      // await db.collection(colectionUser).doc(dataUser.user_id).then((doc2)=>{
      //   if (doc2.exists) {
      //     // 2. Modificar o array removendo o elemento

      //     const atmsArray = doc2.data().atms || [];
      //     const novoAtmsArray = atmsArray.filter((elemento) => elemento.atm_id == doc.atm_id);

      //     // 3. Atualizar o documento com o array modificado
      //     //db.collection(colectionUser).doc(dataUser.user_id).update({ atms: novoAtmsArray });
      //   } else {
      //     console.log('Documento não encontrado.');
      //   }
      // });
    } else {
      // theAtms.push(doc);
    }
    // doc.atms = theAtms;
    firebaseAtms.push(doc);
  });
  console.log(contador);
  console.log("========================");
}

// eslint-disable-next-line camelcase
// eslint-disable-next-line camelcase, require-jsdoc
function hasAtm(estado_dinheiro, estado_online, atm_id) {
  firebaseAtms.forEach((doc) => {
    // eslint-disable-next-line camelcase
    if (doc.atm_id == atm_id) {
      return true;
    }
  });
  return false;
}

// eslint-disable-next-line camelcase, require-jsdoc
async function verifyData(estado_dinheiro, estado_online) {
  firebaseAtms.forEach((doc) => {
    console.log(doc.atm_id);
    // eslint-disable-next-line max-len, camelcase
    if (doc.estado_dinheiro == estado_dinheiro && doc.estado_online == estado_online) {
      return true;
    }
  });
  return false;
}


async function pegarData() {
  let allAtmsBad = [];
  allAtmsGood = [];
  const querySnapshot = await db.collection(colectionUser).get();
  const count = 0;

  console.log(querySnapshot.docs.length);

  for (let index = 0; index < querySnapshot.docs.length; index++) {
    try {
      const dados = querySnapshot.docs[index].data();
      firebaseAtms = [];
      allAtmsBad = [];
      getFirebaseData(dados);
      const postData = {
        identfyed: dados.identfyed,
      };
      const headers = {
        "Authorization": `Bearer ${dados.auth_token}`,
        "Content-Type": "application/json",
      };
      const responsePost = await axios.post(apiUrl, postData, {headers});

      const atms = responsePost.data.dados.atms;
      const status = responsePost.data.dados.status;

      for (let i = 0; i < atms.length; i++) {
        for (let j = 0; j < status.length; j++) {
          let estadoDinheiro = "";
          let estadoOnline = "";
          let controlMoney = false;
          let controlStatus = false;

          if (atms[i].atm_sigit_code == status[j].atm_id) {
            if (status[j].estado_dinheiro == 2) {
              estadoDinheiro = "POUCO DINHEIRO";
              controlMoney = true;
            } else if (status[j].estado_dinheiro != 1 && status[j].estado_dinheiro != 2) {
              estadoDinheiro = "SEM DINHEIRO";
              controlMoney = true;
            }

            if (status[j].is_Horas_ofline > 0) {
              estadoOnline = "OFFLINE";
              controlStatus = true;
            }
            // else{
            //   estado_online = "ONLINE";
            // }

            const dataAtual = new Date();
            const formattedDate = dataAtual.toISOString();

            if (controlMoney == true && controlStatus == true) {
              if ((hasAtm(status[j].estado_dinheiro, estadoOnline, atms[i].atm_sigit_code)) == false) {
                allAtmsBad.push({
                  nome: atms[i].denominacao,
                  satus: false,
                  user_id: 1,
                  estado_online: estadoOnline,
                  estado_mensagem_good: false,
                  estado_mensagem_bad: false,
                  estado_dinheiro: estadoDinheiro,
                  entidade_id: dados.entidade_id,
                  created_at: formattedDate,
                  atm_id: atms[i].atm_sigit_code,
                });
              }
            } else if (controlMoney == true && controlStatus == false) {
              if ((hasAtm(status[j].estado_dinheiro, estadoOnline, atms[i].atm_sigit_code)) == false) {
                allAtmsBad.push({
                  nome: atms[i].denominacao,
                  satus: false,
                  user_id: 1,
                  estado_online: estadoOnline,
                  estado_mensagem_good: false,
                  estado_mensagem_bad: false,
                  estado_dinheiro: estadoDinheiro,
                  entidade_id: dados.entidade_id,
                  created_at: formattedDate,
                  atm_id: atms[i].atm_sigit_code,
                });
              }
            } else if (controlMoney == false && controlStatus == true) {
              if ((hasAtm(status[j].estado_dinheiro, estadoOnline, atms[i].atm_sigit_code)) == false) {
                allAtmsBad.push({
                  nome: atms[i].denominacao,
                  satus: false,
                  user_id: 1,
                  estado_online: estadoOnline,
                  estado_mensagem_good: false,
                  estado_mensagem_bad: false,
                  estado_dinheiro: estadoDinheiro,
                  entidade_id: dados.entidade_id,
                  created_at: formattedDate,
                  atm_id: atms[i].atm_sigit_code,
                });
              } else {
                if (await verifyData(status[j].estado_dinheiro, estadoOnline) != true) {
                  if (status[j].estado_dinheiro == 1 && status[j].is_Horas_ofline == 0) {
                    // emitir alerta e remover do firebase
                  }
                }
              }
            } else {
              allAtmsGood.push({
                nome: atms[i].denominacao,
                satus: false,
                user_id: 1,
                estado_online: estadoOnline,
                estado_mensagem_good: false,
                estado_mensagem_bad: false,
                estado_dinheiro: estadoDinheiro,
                entidade_id: dados.entidade_id,
                created_at: formattedDate,
                atm_id: atms[i].atm_sigit_code,
              });
            }
          }
        }
      }

      console.log("GOOD");
      console.log(allAtmsGood.length);

      for (let index = 0; index < allAtmsGood.length; index++) {
        for (let j = 0; j < allAtmsBad.length; j++) {
          if (allAtmsGood[index].atm_id == allAtmsBad[j].atm_id) {
            sendNotificationToDevice(dados.device_id, allAtmsBad[index].nome, allAtmsBad[index].atm_id.toString(), allAtmsBad[index].estado_dinheiro, allAtmsBad[index].estado_online, 1);
            // EMITIR ALERTA BOM E REMOVER DO FIREBASE;
            // await db.collection(colectionAtm).doc("BAI_"+allAtmsBad[j].atm_id).delete();
            console.log("Já voltou a estar bem.");
          }
        }
      }

      console.log("GOOD 2");
      console.log(allAtmsBad.length);
      console.log("TAMANHO DA COLECTION");
      console.log(firebaseAtms.length);

      let contador = 0;

      if (allAtmsBad.length>0) {
        for (let index = 0; index < allAtmsBad.length; index++) {
          let c = false;
          for (let j = 0; j < firebaseAtms.length; j++) {
            if (allAtmsBad[index].atm_id == firebaseAtms[j].atm_id) {
              c = true;
            }
          }

          if (c == false) {
            contador++;
            sendNotificationToDevice(dados.device_id, allAtmsBad[index].nome, allAtmsBad[index].atm_id.toString(), allAtmsBad[index].estado_dinheiro, allAtmsBad[index].estado_online, 0);
            await db.collection(colectionUser).doc(dados.user_id).update({atms: allAtmsBad});
          }
        }
      }
      console.log("Contador");
      console.log(contador);
    } catch (error) {
      console.error("Erro ao acessar a API:", error.message);
    }

    // const dados = doc.data();
    // firebaseAtms.push(dados);
  }
}

exports.pushNotification = functions.pubsub
    .schedule("*/1 * * * *")
    .timeZone("Africa/Luanda")
    .onRun(async (context) => {
      pegarData();
    });
