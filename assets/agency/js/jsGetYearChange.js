function getYearChange(Crntyear,lessyear) {
	CrntyearSelect1 = String(parseInt(Crntyear.substr(0, 2)) - lessyear);
	CrntyearSelect2 = String(parseInt(Crntyear.substr(2, 4)) - lessyear);
	CrntyearSelectYear = CrntyearSelect1 + CrntyearSelect2;	
		return CrntyearSelectYear;
	
} 