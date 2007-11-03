package com.tobydietrich.svg
{
	public class TestImages
	{
		public static var rectangles:XML = 
		<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
			 width="100%" height="100%" viewBox="0 0 1024 768" style="enable-background:new 0 0 1024 768;" xml:space="preserve">
		<rect x="100" y="63.5" style="fill:#FFFFFF;stroke:#000000;" width="163.043" height="500"/>
		<rect x="200" y="113.848" style="fill:#CC00CC;stroke:#CCCCCC;" width="100" height="400"/>
		<rect x="300" y="170.196" style="fill:#FFFFFF;stroke:#000000;" width="85" height="30"/>
		<rect x="400" y="213.674" style="fill:#FFFFFF;stroke:#000000;" width="34.783" height="115"/>
		</svg>;

		public static var rectanglesResult:XML = <svg viewBoxWidth="1024" viewBoxHeight="768">
  <rect width="163.043" height="500" x="100" y="63.5" isComplex="false" rx="0" ry="0" fill="#FFFFFF" stroke="#000000" stroke-width="0"/>
  <rect width="100" height="400" x="200" y="113.848" isComplex="false" rx="0" ry="0" fill="#CC00CC" stroke="#CCCCCC" stroke-width="0"/>
  <rect width="85" height="30" x="300" y="170.196" isComplex="false" rx="0" ry="0" fill="#FFFFFF" stroke="#000000" stroke-width="0"/>
  <rect width="34.783" height="115" x="400" y="213.674" isComplex="false" rx="0" ry="0" fill="#FFFFFF" stroke="#000000" stroke-width="0"/>
</svg>;

	public static var circles:XML = 
<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="100%" height="100%" viewBox="0 0 1024 768" style="enable-background:new 0 0 1024 768;" xml:space="preserve">
<circle style="fill:#0000FF;stroke:#FF00FF;" cx="341.577" cy="262.27" r="51.923"/>
<circle style="fill:#FFFFFF;stroke:#000000;" cx="400.577" cy="500.27" r="98.923"/>
</svg>;

public static var circlesResult:XML = <svg viewBoxWidth="1024" viewBoxHeight="768">
  <circle cx="341.577" cy="262.27" r="51.923" fill="#0000FF" stroke="#FF00FF" stroke-width="0"/>
  <circle cx="400.577" cy="500.27" r="98.923" fill="#FFFFFF" stroke="#000000" stroke-width="0"/>
</svg>;

public static var ellipses:XML = <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="100%" height="100%" viewBox="0 0 1024 768" style="enable-background:new 0 0 1024 768;" xml:space="preserve">
<ellipse style="fill:#FFFFFF;stroke:#000000;" cx="536.248" cy="326.422" rx="69.985" ry="70"/>
<ellipse style="fill:#FFFFFF;stroke:#000000;" cx="400.248" cy="326.422" rx="90.985" ry="70"/>
</svg>;

public static var ellipsesResult:XML = <svg viewBoxWidth="1024" viewBoxHeight="768">
  <ellipse cx="536.248" cy="326.422" rx="69.985" ry="70" fill="#FFFFFF" stroke="#000000" stroke-width="0"/>
  <ellipse cx="400.248" cy="326.422" rx="90.985" ry="70" fill="#FFFFFF" stroke="#000000" stroke-width="0"/>
</svg>;

	}
}