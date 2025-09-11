$(document).ready(function () {
	try {
	  var hTags = document.getElementsByTagName('h3');
	  for (var i = 0; i < hTags.length; i++) {
			var hTag = hTags[i];
			var content = hTag.innerHTML;
			switch (content) {
			  case "FIRM":
				  hTag.innerHTML=content+`<span data-toggle="tooltip" title="Yaha se firm change kar sakte hai."> &#9432;</span>`;
				break;
				case "TYPE":
					hTag.innerHTML=content+`<span data-toggle="tooltip" title="yaha se aap apka sale purchase etc type kya h vo dal sakte hai."> &#9432;</span>`;
				  break;
				case "PARTY NAME":
					hTag.innerHTML=content+`<span data-toggle="tooltip" title="yaha pe jo b party ka nam dalenge us party ka report open hoga submit karne pe"> &#9432;</span>`;
				  break;
				case "BROKER":
				  hTag.innerHTML=content+`<span data-toggle="tooltip" title="yaha pe jo b Broker ka nam dalenge us Broker ka report open hoga submit karne pe"> &#9432;</span>`;
				break;
				case "CITY":
					hTag.innerHTML=content+`<span data-toggle="tooltip" title="yaha pe jo b city ka nam dalenge us city ka report open hoga submit karne pe"> &#9432;</span>`;
				  break;
				case "GROUP":
					hTag.innerHTML=content+`<span data-toggle="tooltip" title="yaha pe jo b group ka nam dalenge us group ka report open hoga submit karne pe"> &#9432;</span>`;
				  break;
				case "MARKET":
				  hTag.innerHTML=content+`<span data-toggle="tooltip" title="yaha pe jo b market ka nam dalenge us market ka report open hoga submit karne pe"> &#9432;</span>`;
				break;
				case "HASTE":
					hTag.innerHTML=content+`<span data-toggle="tooltip" title="yaha pe jo b haste ka nam dalenge us haste ka report open hoga submit karne pe"> &#9432;</span>`;
				  break;
				case "PRODUCT DETAILS":
				  hTag.innerHTML=content+`<span data-toggle="tooltip" title="age diye gaye box ko tick karke submit karne pe konse bill me kya product gaye h vo report me mill jayegi."> &#9432;</span>`;
				break;
				case "GRADE":
				  hTag.innerHTML=content+`<span data-toggle="tooltip" title="yaha se party grade select kar sakte hai."> &#9432;</span>`;
				break;
				case "SUMMARY REPORT":
				  hTag.innerHTML=content+`<span data-toggle="tooltip" title="age diye gaye box ko tick karke sumit karne pe summary report open hogi."> &#9432;</span>`;
				break;
				case "PENDING EWAY-BILL ONLY":
				  hTag.innerHTML=content+`<span data-toggle="tooltip" title="age diye gaye box ko tick karke sumit karne pe only e-way bill jin bill ke pending h vo report open hogi."> &#9432;</span>`;
				break;
				case ">DAYS FILTER":
				  hTag.innerHTML=content+`<span data-toggle="tooltip" title="yaha pe jitne days dalenge usse upar ke bill show honge uske accordingly report open hogi "> &#9432;</span>`;
				break;
				case "OUTSTANDING PAGE MSG  (AUTO SAVE)":
				  hTag.innerHTML=content+`<span data-toggle="tooltip" title="yaha pe aap agar koi bhi msg dalenge party ke liye vo fir har outstanding me har pdf me niche remark karke jayega"> &#9432;</span>`;
				break;
				case "NOT APPLY ON PAYMENT":
				  hTag.innerHTML=content+`<span data-toggle="tooltip" title="yaha pe tick  karne se date ka filter payment entry par apply nahi hoga"> &#9432;</span>`;
				break;
				case "ORDER BY":
				  hTag.innerHTML=content+`<span data-toggle="tooltip" title="apko report ascending cahiye ya descending chahiye vo change kar sakte hai."> &#9432;</span>`;
				break;
			  default:
				break;
			}
		}
	
	  } catch (error) {
	  //  alert(error);
	  }});



$(document).ready(function(){
	$('[data-toggle="tooltip"]').tooltip();   
  });