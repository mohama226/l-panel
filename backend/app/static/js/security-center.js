async function loadSecurity(){


let res =
await fetch(
"/users/{{user.username}}/security"
);


let data =
await res.json();



document.getElementById(
"security-risk"
).innerHTML =
data.risk;



document.getElementById(
"security-ip-count"
).innerHTML =
data.total_ips;



document.getElementById(
"security-ips"
).innerHTML =

data.ips.map(
ip=>`
<div class="security-item">
🌐 ${ip}
</div>
`
).join("");



document.getElementById(
"security-devices"
).innerHTML =

data.devices.map(
d=>`
<div class="security-item">
📱 ${d}
</div>
`
).join("");



}



loadSecurity();
