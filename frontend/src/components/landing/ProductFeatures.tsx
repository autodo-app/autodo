import * as React from 'react';

const ProductFeatures = (props: any) => {
  return (
    <section className="product-features">
      <h1>Features</h1>
      <div className="core-features">
        <div className="feature-1">
          <div className="iphonePreview">
            <svg version="1.1" viewBox="0 0 0 0">
              <clipPath
                id="screenMask"
                clipPathUnits="objectBoundingBox"
                transform="scale(0.00257, 0.00119)"
              >
                <path
                  d="M6490.24,1234.36H6216.28c-2.57,0-10.55-.07-12.07-0.07a87.524,87.524,0,0,1-12-1.03,40.051,40.051,0,0,1-11.4-3.79,38.315,38.315,0,0,1-16.82-16.84,39.948,39.948,0,0,1-3.78-11.42,72.257,72.257,0,0,1-1.04-12.02c-0.06-1.83-.06-5.56-0.06-5.56V452.125h0s0.06-11.391.06-12.086a87.9,87.9,0,0,1,1.04-12.025,39.843,39.843,0,0,1,3.78-11.413,38.283,38.283,0,0,1,16.82-16.847,39.762,39.762,0,0,1,11.4-3.785,71.909,71.909,0,0,1,12-1.037c16.99-.567,36.32-0.061,34.51-0.061,5.02,0,6.5,3.439,6.63,6.962a35.611,35.611,0,0,0,1.2,8.156,21.326,21.326,0,0,0,19.18,15.592c2.28,0.192,6.78.355,6.78,0.355H6433.7s4.5-.059,6.79-0.251a21.348,21.348,0,0,0,19.18-15.591,35.582,35.582,0,0,0,1.19-8.154c0.13-3.523,1.61-6.962,6.64-6.962-1.81,0,17.52-.5,34.5.061a71.923,71.923,0,0,1,12.01,1.038,39.832,39.832,0,0,1,11.4,3.784,38.283,38.283,0,0,1,16.82,16.844,40.153,40.153,0,0,1,3.78,11.413,87.844,87.844,0,0,1,1.03,12.023c0,0.695.06,12.084,0.06,12.084h0V1183.64s0,3.72-.06,5.55a72.366,72.366,0,0,1-1.03,12.03,40.2,40.2,0,0,1-3.78,11.41,38.315,38.315,0,0,1-16.82,16.84,40.155,40.155,0,0,1-11.4,3.79,87.669,87.669,0,0,1-12.01,1.03c-1.52,0-9.5.07-12.07,0.07"
                  transform="translate(-6159.12 -394.656)"
                />
              </clipPath>
            </svg>

            <img
              className="iphoneScreen hidden"
              src="../assets/homescreen_ios_hires.jpg"
              alt=""
            />
          </div>
          <div className="description-1">
            <h3>Create Recurring Tasks</h3>
            <p>Tasks can repeat by your car's mileage, time, or both.</p>
            <h3>Keep Track of Fuel Usage and Mileage</h3>
            <p>
              Stay in the loop on your car's gas mileage and see graphs of its
              stats. As a bonus, every refueling you log improves auToDo's
              predictions about when your car will need maintenance.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default ProductFeatures;
