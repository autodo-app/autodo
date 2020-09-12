import * as React from 'react';

const ProductBenefits = (props: any) => {
  return (
    <section id="about" className="product-benefits">
      <div className="product-benefits-group">
        <div className="product-benefit-1-tagline">
          Get reminders for your car's routine maintenance that work.
        </div>
        <div className="product-benefit-1-image"></div>
        <div className="product-benefit-2-tagline">
          Keep track of your car on any device.
        </div>
        <div className="product-benefit-2-image"></div>
        <div className="product-benefit-3-tagline">
          Every logged refueling improves the notifications for tasks.
        </div>
        <div className="product-benefit-3-image"></div>
      </div>
    </section>
  );
};

export default ProductBenefits;
