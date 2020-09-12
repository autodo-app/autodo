import * as React from 'react';

const ProductFeatures = (props: any) => {
  return (
    <section className="product-features">
      <h1>Our Product Features</h1>
      <div className="core-features">
        <div className="core-feature-1">
          <div className="core-feature-1-image">
            <svg
              className="background-feature-1"
              viewBox="0 0 200 200"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                fill-opacity="0.7"
                fill="#08BDBA"
                d="M55.2,-60.8C66.2,-44.2,66.2,-22.1,65.2,-1C64.2,20.2,62.3,40.3,51.3,50.8C40.3,61.3,20.2,62,-1.2,63.2C-22.5,64.4,-45.1,66,-58.1,55.5C-71.2,45.1,-74.9,22.5,-71.8,3C-68.8,-16.4,-59,-32.9,-46,-49.5C-32.9,-66.1,-16.4,-83,2.8,-85.8C22.1,-88.6,44.2,-77.5,55.2,-60.8Z"
                transform="translate(100 100)"
              />
            </svg>
            <svg
              version="1.1"
              className="icon-hearbeat"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 800 800"
            >
              <path
                d="M369.75,21.675c-43.35,0-86.7,20.4-114.75,53.55c-28.05-33.15-71.4-53.55-114.75-53.55C61.2,21.675,0,82.875,0,161.925
              c0,96.9,86.7,175.95,219.3,293.25l35.7,33.15l35.7-33.15c130.05-119.85,219.3-198.9,219.3-293.25
              C510,82.875,448.8,21.675,369.75,21.675z M257.55,419.475H255l-2.55-2.55C130.05,307.274,51,235.875,51,161.925
              c0-51,38.25-89.25,89.25-89.25c38.25,0,76.5,25.5,91.8,61.2h48.45c12.75-35.7,51-61.2,89.25-61.2c51,0,89.25,38.25,89.25,89.25
              C459,235.875,379.95,307.274,257.55,419.475z"
              />
            </svg>
          </div>
          <h2>This is our feature 1.</h2>
          <p>We will bring you love.</p>
        </div>
        <div className="core-feature-3">
          <div className="core-feature-3-image">
            <svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
              <path
                fill="#FA4D56"
                fill-opacity="0.8"
                d="M47.7,-57.2C59,-47.3,63.6,-29.7,68.3,-10.9C72.9,7.9,77.8,27.8,71.7,44.2C65.6,60.7,48.6,73.6,33.3,69.7C18.1,65.7,4.7,44.8,-13.2,37.7C-31.1,30.5,-53.5,37.2,-57.9,32.2C-62.3,27.2,-48.6,10.5,-44.1,-6.5C-39.6,-23.5,-44.1,-40.7,-38.3,-51.5C-32.5,-62.4,-16.2,-66.7,1,-67.9C18.2,-69,36.3,-67,47.7,-57.2Z"
                transform="translate(100 100)"
              />
            </svg>
            <svg
              className="icon-wrench"
              viewBox="0 0 700 700"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path d="M0 316c0 15 6 29 16 40l12 11c10 11 24 16 39 16s29-5 40-16l115-115a128 128 0 0 0 161-124c0-18-3-35-10-51l-1-1v-1l-1-2-1-1-1-1-2-1-1-1-1-1-1-1h-3l-2-1h-3l-2 1h-1l-2 1h-1l-1 1-2 1-1 1-68 68-33-34 67-68 1-1 1-1 1-2 1-1v-2l1-1v-1-2-1-2l-1-2v-1l-1-1v-2l-1-1-1-1-1-1-2-1-1-1-1-1h-1a128 128 0 0 0-175 150L16 276a56 56 0 0 0-16 40zM255 32l16 1-49 49a32 32 0 0 0 0 46l34 34a32 32 0 0 0 45 0l49-49 1 15a96 96 0 0 1-128 90 96 96 0 0 1 32-186zM39 299l106-106 1 2 6 8 3 4c6 8 13 15 21 22l4 2 9 6 1 1L84 344c-9 9-25 10-34 0l-11-11a24 24 0 0 1 0-34zm0 0" />
            </svg>
          </div>
          <h2>This is our feature 2.</h2>
          <p>We will fix everything.</p>
        </div>
        <div className="core-feature-2">
          <div className="core-feature-1-image">
            <svg viewBox="0 20 180 180" xmlns="http://www.w3.org/2000/svg">
              <path
                fill="#F1C21B"
                fill-opacity="0.7"
                d="M48.2,-46.1C57.2,-39.2,55.7,-19.6,54.6,-1.1C53.5,17.5,53,35,44,43C35,51.1,17.5,49.6,-1.9,51.5C-21.2,53.4,-42.5,58.5,-56.8,50.5C-71.1,42.5,-78.5,21.2,-71.3,7.2C-64.1,-6.8,-42.3,-13.6,-28,-20.5C-13.6,-27.3,-6.8,-34.1,6.4,-40.5C19.6,-46.9,39.2,-52.9,48.2,-46.1Z"
                transform="translate(100 100)"
              />
            </svg>
            <svg
              className="icon-paint"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 40 40"
            >
              <path d="M18 1h-8a3 3 0 0 0-3 3H6a3 3 0 0 0-3 3v3a3 3 0 0 0 3 3h6a1 1 0 0 1 1 1v1a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2v-4a2 2 0 0 0-2-2v-1a3 3 0 0 0-3-3H6a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1h1a3 3 0 0 0 3 3h8a3 3 0 0 0 3-3V4a3 3 0 0 0-3-3zm-3 16v4h-2v-4zm4-11a1 1 0 0 1-1 1h-8a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h8a1 1 0 0 1 1 1z" />
            </svg>
          </div>
          <h2>This is our feature 3.</h2>
          <p>We will cleanup the mess.</p>
        </div>
      </div>
    </section>
  );
};

export default ProductFeatures;
