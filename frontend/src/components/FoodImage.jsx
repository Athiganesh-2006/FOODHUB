import { useState } from "react";

/**
 * Food image with a graceful missing-image state.
 *
 * `src` is the backend FoodDTO.imageUrl (e.g. "/images/foods/masala-dosa.png",
 * served from public/). If it is empty or the file 404s (PNG not added yet) we
 * render the plain "No image" box instead — no broken-image icon, no crash.
 */
const FoodImage = ({ src, alt, className = "food-image" }) => {
  const [failed, setFailed] = useState(false);

  if (!src || failed) {
    return (
      <div
        className={`${className} food-image--missing`}
        role="img"
        aria-label={alt ? `${alt} — no image` : "No image"}
      >
        <span>No image</span>
      </div>
    );
  }

  return (
    <img
      className={className}
      src={src}
      alt={alt || ""}
      loading="lazy"
      onError={() => setFailed(true)}
    />
  );
};

export default FoodImage;
