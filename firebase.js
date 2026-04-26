import { initializeApp } from "https://www.gstatic.com/firebasejs/12.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/12.12.1/firebase-analytics.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/12.12.1/firebase-auth.js";

const firebaseConfig = {
  apiKey: "AIzaSyCfd3c9GowIF54iHhRdgUZoB8VQi29UP_s",
  authDomain: "project-backend-a1776.firebaseapp.com",
  projectId: "project-backend-a1776",
  storageBucket: "project-backend-a1776.firebasestorage.app",
  messagingSenderId: "111290478535",
  appId: "1:111290478535:web:0d69a25ad59875e02a73e2",
  measurementId: "G-M9YWPP4E1Z"
};

const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const auth = getAuth(app);

export { app, auth };